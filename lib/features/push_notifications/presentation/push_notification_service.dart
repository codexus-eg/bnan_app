import 'dart:async';
import 'dart:convert';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_messaging.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_token_registrar.dart';
import 'package:bnan_app/features/push_notifications/presentation/local_push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  PushNotificationService({
    required this.firebaseAvailable,
    required PushMessaging messaging,
    required PushTokenRegistrar registrar,
    required ChatNotificationCoordinator chat,
    NotificationsCubit? notifications,
    LocalPushNotifications? localNotifications,
    Stream<RemoteMessage>? foregroundMessages,
    Stream<RemoteMessage>? openedMessages,
  }) : _messaging = messaging,
       _registrar = registrar,
       _chat = chat,
       _notifications = notifications,
       _localNotifications = localNotifications,
       _foregroundMessages = foregroundMessages ?? FirebaseMessaging.onMessage,
       _openedMessages = openedMessages ?? FirebaseMessaging.onMessageOpenedApp;

  final bool firebaseAvailable;
  final PushMessaging _messaging;
  final PushTokenRegistrar _registrar;
  final ChatNotificationCoordinator _chat;
  final NotificationsCubit? _notifications;
  final LocalPushNotifications? _localNotifications;
  final Stream<RemoteMessage> _foregroundMessages;
  final Stream<RemoteMessage> _openedMessages;
  final _opened = StreamController<ChatPushIntent>.broadcast();
  final _notificationOpened = StreamController<AppNotification>.broadcast();
  final Set<String> _navigationIds = {};
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  ChatPushIntent? _pending;
  AppNotification? _pendingNotification;
  bool _initialized = false;

  Stream<ChatPushIntent> get opened => _opened.stream;
  Stream<AppNotification> get notificationOpened => _notificationOpened.stream;

  Future<void> initialize() async {
    if (!firebaseAvailable || _initialized) return;
    _initialized = true;
    _subscriptions.addAll([
      _foregroundMessages.listen(_handleForeground),
      _openedMessages.listen(_handleOpened),
      _messaging.tokenRefresh.listen(_handleTokenRefresh),
    ]);
    await _localNotifications?.initialize(_handleLocalPayload);
    final initialLocalPayload = await _localNotifications?.initialPayload();
    if (initialLocalPayload?.isNotEmpty == true) {
      _handleLocalPayload(initialLocalPayload!);
    }
    SessionManager.instance.addAccessTokenChangeListener(_onTokenChanged);
    SessionManager.instance.addBeforeClearListener(_beforeSessionClear);
    _handleOpened(await _messaging.getInitialMessage());
    if (SessionManager.instance.accessToken?.isNotEmpty == true) {
      unawaited(_registrar.registerCurrent());
    }
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    final notification = _notification(message);
    if (notification != null) {
      _notifications?.ingest(notification);
    }
    final intent = _intent(message);
    if (intent == null) return;
    final result = _chat.handlePush(
      messageId: intent.messageId,
      notificationId: intent.notificationId,
      roomId: intent.roomId,
      senderId: intent.senderId,
      title: intent.title,
      body: intent.body,
      roomName: intent.roomName,
    );
    if (result == ChatForegroundNotificationResult.duplicate) {
      debugPrint('FCM_FOREGROUND_DEDUPED');
      debugPrint('notificationId: ${intent.dedupKey}');
    }
  }

  void _handleOpened(RemoteMessage? message) {
    if (message != null) {
      _queueOrOpenNotification(_notification(message));
      _queueOrOpen(_intent(message));
    }
  }

  ChatPushIntent? _intent(RemoteMessage message) => ChatPushIntent.tryParse(
    message.data,
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
  );

  AppNotification? _notification(RemoteMessage message) {
    final data = <String, dynamic>{...message.data};
    data['_title'] = message.notification?.title;
    data['_body'] = message.notification?.body;
    final value = AppNotification.fromJson(data);
    return value.id.isEmpty && value.key.isEmpty ? null : value;
  }

  void _handleLocalPayload(String payload) {
    try {
      final value = jsonDecode(payload);
      if (value is Map) {
        _queueOrOpenNotification(
          AppNotification.fromJson(Map<String, dynamic>.from(value)),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Notification payload failed: ${error.runtimeType}');
      }
    }
  }

  void _queueOrOpenNotification(AppNotification? value) {
    if (value == null) return;
    if (SessionManager.instance.accessToken?.isNotEmpty != true) {
      _pendingNotification = value;
      return;
    }
    _notificationOpened.add(value);
  }

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
    final pendingNotification = _pendingNotification;
    _pendingNotification = null;
    _queueOrOpenNotification(pendingNotification);
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
    await _notificationOpened.close();
  }
}
