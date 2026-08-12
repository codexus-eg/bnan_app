import 'dart:async';
import 'dart:convert';

import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/push_notifications/presentation/local_push_notifications.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_token_registrar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  PushNotificationService({
    required this.firebaseAvailable,
    required FirebaseMessaging messaging,
    required LocalPushNotifications local,
    required PushTokenRegistrar registrar,
    required ChatNotificationCoordinator chat,
  }) : _messaging = messaging,
       _local = local,
       _registrar = registrar,
       _chat = chat;

  final bool firebaseAvailable;
  final FirebaseMessaging _messaging;
  final LocalPushNotifications _local;
  final PushTokenRegistrar _registrar;
  final ChatNotificationCoordinator _chat;
  final _opened = StreamController<ChatPushIntent>.broadcast();
  final Set<String> _navigationIds = {};
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  ChatPushIntent? _pending;
  bool _initialized = false;

  Stream<ChatPushIntent> get opened => _opened.stream;

  Future<void> initialize() async {
    if (!firebaseAvailable || _initialized) return;
    _initialized = true;
    await _local.initialize(_handleLocalPayload);
    _subscriptions.addAll([
      FirebaseMessaging.onMessage.listen(_handleForeground),
      FirebaseMessaging.onMessageOpenedApp.listen(_handleOpened),
      _messaging.onTokenRefresh.listen(_handleTokenRefresh),
    ]);
    SessionManager.instance.addSessionChangeListener(_onSessionChanged);
    SessionManager.instance.addBeforeClearListener(_beforeSessionClear);
    _handleOpened(await _messaging.getInitialMessage());
    _handleLocalPayload(await _local.initialPayload());
    if (SessionManager.instance.accessToken?.isNotEmpty == true) {
      unawaited(_registrar.registerCurrent());
    }
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    final intent = _intent(message);
    if (intent == null ||
        !_chat.claimPushAlert(
          messageId: intent.dedupKey,
          roomId: intent.roomId,
          senderId: intent.senderId,
        )) {
      return;
    }
    await _local.show(intent, message.data);
  }

  void _handleOpened(RemoteMessage? message) {
    if (message != null) {
      _queueOrOpen(_intent(message));
    }
  }

  void _handleLocalPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload) as Map);
      _queueOrOpen(
        ChatPushIntent.tryParse(
          data,
          title: data['_title']?.toString() ?? '',
          body: data['_body']?.toString() ?? '',
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Invalid local push payload: ${error.runtimeType}');
      }
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

  Future<void> _onSessionChanged(String? previous, String? next) async {
    if (next?.trim().isEmpty != false) return;
    final pending = _pending;
    _pending = null;
    _queueOrOpen(pending);
    await _registrar.registerCurrent();
  }

  Future<void> _beforeSessionClear() => _registrar.deleteCurrent();

  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    SessionManager.instance.removeSessionChangeListener(_onSessionChanged);
    SessionManager.instance.removeBeforeClearListener(_beforeSessionClear);
    await _opened.close();
  }
}
