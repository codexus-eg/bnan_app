import 'dart:async';

import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_notification_model.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract interface class ChatForegroundAlert {
  Future<void> play();
}

class NativeChatForegroundAlert implements ChatForegroundAlert {
  const NativeChatForegroundAlert();

  static const _channel = MethodChannel('bnan/notification_sound');

  @override
  Future<void> play() =>
      _channel.invokeMethod<void>('playDefaultNotificationSound');
}

enum ChatForegroundNotificationResult { shown, currentChat, duplicate, ignored }

class ChatNotificationCoordinator {
  ChatNotificationCoordinator(
    this.socketService, {
    ChatForegroundAlert alert = const NativeChatForegroundAlert(),
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
  void Function(Map<String, dynamic> payload)? _notificationHandler;

  Stream<ChatNotificationEvent> get roomEvents => _roomEvents.stream;
  Stream<ChatNotificationEvent> get foregroundEvents =>
      _foregroundEvents.stream;
  String? get currentRoomId => _currentRoomId;
  int get listenerCount => _listenerDisposers.length;

  void setNotificationHandler(
    void Function(Map<String, dynamic> payload) handler,
  ) {
    _notificationHandler = handler;
  }

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
    _notificationHandler?.call(payload);
    final notification = ChatNotificationModel.fromJson(payload);
    if (notification.isChatMessage) {
      _handle(ChatNotificationEvent.fromNotification(notification));
    } else if (notification.isRoomOrClassroomUpdate) {
      handleRoomCreated(payload);
    }
  }

  void handleRoomCreated(Map<String, dynamic> payload) {
    final roomId = (payload['roomId'] ??
            payload['id'] ??
            payload['_id'] ??
            payload['chatRoomId'] ??
            payload['classroomId'])
        ?.toString()
        .trim() ??
        '';
    _roomEvents.add(
      ChatNotificationEvent(
        messageId: 'room_event_${DateTime.now().microsecondsSinceEpoch}',
        roomId: roomId,
        senderId: '',
        senderName: '',
        message: '',
        createdAt: DateTime.now(),
      ),
    );
  }

  ChatForegroundNotificationResult handlePush({
    required String messageId,
    required String notificationId,
    required String roomId,
    required String senderId,
    required String title,
    required String body,
    String roomName = '',
  }) {
    return _handle(
      ChatNotificationEvent.fromPush(
        messageId: messageId,
        notificationId: notificationId,
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

  ChatForegroundNotificationResult _handle(
    ChatNotificationEvent event, {
    bool updateRoom = true,
  }) {
    final id = event.messageId.trim();
    final notificationId = event.notificationId.trim();
    final keys = {
      if (notificationId.isNotEmpty) notificationId,
      if (id.isNotEmpty) id,
    };
    if (keys.isEmpty) return ChatForegroundNotificationResult.ignored;

    if (updateRoom && event.roomId.isNotEmpty && _roomUpdateIds.add(id)) {
      _roomEvents.add(event);
    }
    if (keys.any(_notifiedIds.contains)) {
      _soundSkipped(notificationId.isEmpty ? id : notificationId, 'duplicate');
      return ChatForegroundNotificationResult.duplicate;
    }
    _notifiedIds.addAll(keys);
    _trimDedupSets();

    final currentUserId = _currentUserId()?.trim() ?? '';
    if (event.senderId.isNotEmpty && event.senderId == currentUserId) {
      return ChatForegroundNotificationResult.ignored;
    }
    if (event.roomId.isNotEmpty && event.roomId == _currentRoomId) {
      _soundSkipped(
        notificationId.isEmpty ? id : notificationId,
        'current_chat',
      );
      return ChatForegroundNotificationResult.currentChat;
    }

    unawaited(_playSound(notificationId.isEmpty ? id : notificationId));
    _foregroundEvents.add(event);
    return ChatForegroundNotificationResult.shown;
  }

  Future<void> _playSound(String notificationId) async {
    debugPrint('IN_APP_SOUND_REQUESTED');
    debugPrint('notificationId: $notificationId');
    debugPrint('implementation: ${_alert.runtimeType}');
    debugPrint(
      'appLifecycleState: '
      '${WidgetsBinding.instance.lifecycleState?.name ?? 'unknown'}',
    );
    try {
      await _alert.play();
      debugPrint('IN_APP_SOUND_CALL_COMPLETED');
      debugPrint('notificationId: $notificationId');
    } catch (error) {
      debugPrint('IN_APP_SOUND_ERROR');
      debugPrint('notificationId: $notificationId');
      debugPrint('error: $error');
    }
  }

  void _soundSkipped(String notificationId, String reason) {
    debugPrint('IN_APP_NOTIFICATION_SOUND_SKIPPED');
    debugPrint('reason: $reason');
    debugPrint('notificationId: $notificationId');
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
    _notificationHandler = null;
    _session.removeSessionChangeListener(_onSessionChanged);
    await _roomEvents.close();
    await _foregroundEvents.close();
  }
}
