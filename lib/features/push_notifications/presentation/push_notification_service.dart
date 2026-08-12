import 'dart:async';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_messaging.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_token_registrar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  PushNotificationService({
    required this.firebaseAvailable,
    required PushMessaging messaging,
    required PushTokenRegistrar registrar,
    required ChatNotificationCoordinator chat,
    Stream<RemoteMessage>? foregroundMessages,
    Stream<RemoteMessage>? openedMessages,
  }) : _messaging = messaging,
       _registrar = registrar,
       _chat = chat,
       _foregroundMessages = foregroundMessages ?? FirebaseMessaging.onMessage,
       _openedMessages = openedMessages ?? FirebaseMessaging.onMessageOpenedApp;

  final bool firebaseAvailable;
  final PushMessaging _messaging;
  final PushTokenRegistrar _registrar;
  final ChatNotificationCoordinator _chat;
  final Stream<RemoteMessage> _foregroundMessages;
  final Stream<RemoteMessage> _openedMessages;
  final _opened = StreamController<ChatPushIntent>.broadcast();
  final Set<String> _navigationIds = {};
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  ChatPushIntent? _pending;
  bool _initialized = false;

  Stream<ChatPushIntent> get opened => _opened.stream;

  Future<void> initialize() async {
    if (!firebaseAvailable || _initialized) return;
    _initialized = true;
    _subscriptions.addAll([
      _foregroundMessages.listen(_handleForeground),
      _openedMessages.listen(_handleOpened),
      _messaging.tokenRefresh.listen(_handleTokenRefresh),
    ]);
    SessionManager.instance.addAccessTokenChangeListener(_onTokenChanged);
    SessionManager.instance.addBeforeClearListener(_beforeSessionClear);
    _handleOpened(await _messaging.getInitialMessage());
    if (SessionManager.instance.accessToken?.isNotEmpty == true) {
      unawaited(_registrar.registerCurrent());
    }
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    final intent = _intent(message);
    if (intent == null) return;
    _chat.handlePush(
      messageId: intent.dedupKey,
      roomId: intent.roomId,
      senderId: intent.senderId,
      title: intent.title,
      body: intent.body,
    );
  }

  void _handleOpened(RemoteMessage? message) {
    if (message != null) {
      _queueOrOpen(_intent(message));
    }
  }

  ChatPushIntent? _intent(RemoteMessage message) => ChatPushIntent.tryParse(
    message.data,
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
  );

  void _queueOrOpen(ChatPushIntent? intent) {
    if (intent == null || intent.roomId == _chat.currentRoomId) return;
    if (SessionManager.instance.accessToken?.isNotEmpty != true) {
      _pending = intent;
      return;
    }
    final key = intent.dedupKey;
    if (key.isNotEmpty && !_navigationIds.add(key)) return;
    if (_navigationIds.length > 200) {
      _navigationIds.remove(_navigationIds.first);
    }
    _opened.add(intent);
  }

  Future<void> _handleTokenRefresh(String token) async {
    try {
      await _registrar.register(token);
    } catch (error) {
      if (kDebugMode) debugPrint('Push refresh failed: ${error.runtimeType}');
    }
  }

  void _onTokenChanged(String? token) {
    if (token?.trim().isEmpty != false) return;
    final pending = _pending;
    _pending = null;
    _queueOrOpen(pending);
    unawaited(_registrar.registerCurrent());
  }

  Future<void> _beforeSessionClear() => _registrar.deleteCurrent();

  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    SessionManager.instance.removeAccessTokenChangeListener(_onTokenChanged);
    SessionManager.instance.removeBeforeClearListener(_beforeSessionClear);
    await _opened.close();
  }
}
