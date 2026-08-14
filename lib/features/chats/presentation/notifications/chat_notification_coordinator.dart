import 'dart:async';

import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_notification_model.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract interface class ChatForegroundAlert {
  Future<void> play();
}

class SystemChatForegroundAlert implements ChatForegroundAlert {
  const SystemChatForegroundAlert();

  @override
  Future<void> play() => SystemSound.play(SystemSoundType.alert);
}

class ChatNotificationCoordinator {
  ChatNotificationCoordinator(
    this.socketService, {
    ChatForegroundAlert alert = const SystemChatForegroundAlert(),
    SessionManager? session,
    String? Function()? currentUserId,
  }) : _alert = alert,
       _session = session ?? SessionManager.instance,
       _currentUserId = currentUserId ?? (() => SessionManager.instance.userId);

  final SocketService socketService;
  final ChatForegroundAlert _alert;
  final SessionManager _session;
  final String? Function() _currentUserId;
  final _roomEvents = StreamController<ChatNotificationEvent>.broadcast();
  final _foregroundEvents = StreamController<ChatNotificationEvent>.broadcast();
  final Set<String> _notifiedIds = {};
  final Set<String> _roomUpdateIds = {};
  final List<VoidCallback> _listenerDisposers = [];
  String? _currentRoomId;
  bool _initialized = false;
  bool _starting = false;

  Stream<ChatNotificationEvent> get roomEvents => _roomEvents.stream;
  Stream<ChatNotificationEvent> get foregroundEvents =>
      _foregroundEvents.stream;
  String? get currentRoomId => _currentRoomId;
  int get listenerCount => _listenerDisposers.length;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _session.addSessionChangeListener(_onSessionChanged);
    if (_session.userId?.trim().isNotEmpty == true) await start();
  }

  Future<void> start() async {
    if (_starting || _listenerDisposers.isNotEmpty) return;
    _starting = true;
    try {
      await socketService.connect();
      _listenerDisposers.addAll([
        socketService.listenToNewMessage(handleMessage),
        socketService.listenToNotification(handleNotification),
      ]);
    } catch (error) {
      debugPrint('Chat notification socket unavailable: $error');
    } finally {
      _starting = false;
    }
  }

  void enterRoom(String roomId) {
    final value = roomId.trim();
    _currentRoomId = value.isEmpty ? null : value;
  }

  void leaveRoom(String roomId) {
    if (_currentRoomId == roomId.trim()) _currentRoomId = null;
  }

  void handleMessage(ChatMessageModel message) {
    _handle(ChatNotificationEvent.fromMessage(message));
  }

  void handleNotification(Map<String, dynamic> payload) {
    final notification = ChatNotificationModel.fromJson(payload);
    if (!notification.isChatMessage) return;
    _handle(ChatNotificationEvent.fromNotification(notification));
  }

  void handlePush({
    required String messageId,
    required String roomId,
    required String senderId,
    required String title,
    required String body,
    String roomName = '',
  }) {
    _handle(
      ChatNotificationEvent.fromPush(
        messageId: messageId,
        roomId: roomId,
        senderId: senderId,
        senderName: title,
        message: body,
        roomName: roomName,
      ),
      updateRoom: false,
    );
  }

  bool claimPushAlert({
    required String messageId,
    required String roomId,
    required String senderId,
  }) {
    final id = messageId.trim();
    if (id.isEmpty || !_notifiedIds.add(id)) return false;
    _trimDedupSets();
    final userId = _currentUserId()?.trim() ?? '';
    if (senderId.trim().isNotEmpty && senderId.trim() == userId) return false;
    return roomId.trim().isNotEmpty && roomId.trim() != _currentRoomId;
  }

  void _handle(ChatNotificationEvent event, {bool updateRoom = true}) {
    final id = event.messageId.trim();
    if (id.isEmpty) return;

    if (updateRoom && event.roomId.isNotEmpty && _roomUpdateIds.add(id)) {
      _roomEvents.add(event);
    }
    if (!_notifiedIds.add(id)) return;
    _trimDedupSets();

    final currentUserId = _currentUserId()?.trim() ?? '';
    if (event.senderId.isNotEmpty && event.senderId == currentUserId) return;
    if (event.roomId.isNotEmpty && event.roomId == _currentRoomId) return;

    unawaited(_alert.play());
    _foregroundEvents.add(event);
  }

  void _trimDedupSets() {
    if (_notifiedIds.length <= 500) return;
    _notifiedIds.remove(_notifiedIds.first);
    if (_roomUpdateIds.length > 500) {
      _roomUpdateIds.remove(_roomUpdateIds.first);
    }
  }

  Future<void> _onSessionChanged(String? previous, String? next) async {
    stop(disconnect: true);
    if (next?.trim().isNotEmpty == true) await start();
  }

  void stop({bool disconnect = false}) {
    for (final disposeListener in _listenerDisposers) {
      disposeListener();
    }
    _listenerDisposers.clear();
    _currentRoomId = null;
    _notifiedIds.clear();
    _roomUpdateIds.clear();
    if (disconnect) socketService.disconnect();
  }

  Future<void> dispose() async {
    stop();
    _session.removeSessionChangeListener(_onSessionChanged);
    await _roomEvents.close();
    await _foregroundEvents.close();
  }
}
