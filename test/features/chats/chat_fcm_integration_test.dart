import 'dart:async';

import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_sender_model.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_route.dart';
import 'package:bnan_app/features/push_notifications/data/installation_id_store.dart';
import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/push_notifications/data/models/device_token_payload.dart';
import 'package:bnan_app/features/push_notifications/data/repo/device_token_repo.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_messaging.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_notification_service.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_token_registrar.dart';
import 'package:bnan_app/features/push_notifications/presentation/local_push_notifications.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await CacheHelper.clear();
    await SessionManager.instance.clearSession();
    PackageInfo.setMockInitialValues(
      appName: 'Bnan',
      packageName: 'com.bnanacademy.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  test(
    'register, refresh, and logout use one stable installation id',
    () async {
      await _login();
      final messaging = _Messaging('fcm-1');
      final repo = _TokenRepo();
      final registrar = PushTokenRegistrar(
        messaging,
        repo,
        InstallationIdStore(),
      );

      await registrar.registerCurrent();
      await registrar.register('fcm-2');
      messaging.token = 'fcm-2';
      await registrar.deleteCurrent();

      expect(repo.registered.map((item) => item.token), ['fcm-1', 'fcm-2']);
      expect(
        repo.registered.map((item) => item.deviceId).toSet(),
        hasLength(1),
      );
      expect(repo.registered.last.appVersion, '1.0.0');
      expect(repo.deleted, ['fcm-1', 'fcm-2']);
    },
  );

  test('account switch detaches token before registering new owner', () async {
    await _login(userId: 'student-1');
    final messaging = _Messaging('shared-fcm');
    final repo = _TokenRepo();
    final registrar = PushTokenRegistrar(
      messaging,
      repo,
      InstallationIdStore(),
    );
    await registrar.registerCurrent();

    final unregisterOldToken = registrar.deleteCurrent;
    SessionManager.instance.addBeforeClearListener(unregisterOldToken);
    try {
      await _login(userId: 'supervisor-1');
      await registrar.registerCurrent();
    } finally {
      SessionManager.instance.removeBeforeClearListener(unregisterOldToken);
    }

    expect(repo.operations, [
      'register:shared-fcm',
      'delete:shared-fcm',
      'register:shared-fcm',
    ]);
  });

  test('token refresh cannot re-register after logout starts', () async {
    await _login(userId: 'student-1');
    final messaging = _Messaging('shared-fcm');
    final repo = _TokenRepo();
    final registrar = PushTokenRegistrar(
      messaging,
      repo,
      InstallationIdStore(),
    );
    await registrar.registerCurrent();

    final logout = registrar.deleteCurrent();
    await registrar.register('refreshed-after-logout');
    await logout;

    expect(repo.registered.map((item) => item.token), ['shared-fcm']);
    expect(repo.deleted, ['shared-fcm']);
  });

  test('role switch without user ids detaches the old token owner', () async {
    await _login(userId: '', userRole: 'student');
    final messaging = _Messaging('shared-fcm');
    final repo = _TokenRepo();
    final registrar = PushTokenRegistrar(
      messaging,
      repo,
      InstallationIdStore(),
    );
    SessionManager.instance.addBeforeClearListener(registrar.deleteCurrent);
    try {
      await registrar.registerCurrent();
      await _login(userId: '', userRole: 'supervisor');
      await registrar.registerCurrent();
    } finally {
      SessionManager.instance.removeBeforeClearListener(
        registrar.deleteCurrent,
      );
    }

    expect(repo.operations, [
      'register:shared-fcm',
      'delete:shared-fcm',
      'register:shared-fcm',
    ]);
  });

  test('supervisor session suppresses stale student call push', () async {
    await _login(userRole: 'supervisor');
    final local = _LocalNotifications();
    final harness = await _service(localNotifications: local);
    harness.foreground.add(
      RemoteMessage(
        data: const {
          'key': 'STUDENT_CALL_ALERT',
          'callId': 'call-1',
          'notificationId': 'notification-1',
        },
      ),
    );
    await _flush();

    expect(local.shown, isEmpty);
    await harness.dispose();
  });

  test('payload prefers resourceId and safely falls back to params', () {
    final direct = ChatPushIntent.tryParse({
      'key': 'NEW_MESSAGE',
      'notificationType': 'chat',
      'resourceId': 'room-resource',
      'params': '{"roomId":"room-params"}',
    });
    final fallback = ChatPushIntent.tryParse({
      'notificationType': 'chat',
      'params': '{"chatId":"room-fallback"}',
    });

    expect(direct?.roomId, 'room-resource');
    expect(fallback?.roomId, 'room-fallback');
    expect(ChatNotificationRoute.path(direct?.roomId), '/chat/room-resource');
  });

  test(
    'foreground deduplicates socket/FCM and suppresses current room',
    () async {
      await _login();
      final harness = await _service();
      final alerts = <String>[];
      final subscription = harness.chat.foregroundEvents.listen(
        (event) => alerts.add(event.messageId),
      );

      harness.foreground.add(_message('room-1', messageId: 'message-1'));
      harness.chat.handleMessage(_socketMessage('message-1', 'room-1'));
      harness.chat.enterRoom('room-2');
      harness.foreground.add(_message('room-2', messageId: 'message-2'));
      await _flush();

      expect(alerts, ['message-1']);
      await subscription.cancel();
      await harness.dispose();
    },
  );

  test('refresh, opened-app route, and logout cleanup are wired', () async {
    await _login();
    final harness = await _service();
    final routes = <String?>[];
    final subscription = harness.service.opened.listen(
      (intent) => routes.add(ChatNotificationRoute.path(intent.roomId)),
    );

    harness.refresh.add('fresh-fcm');
    harness.opened.add(_message('room/open'));
    await _flush();
    await SessionManager.instance.clearTokens();

    expect(harness.registrar.refreshed, ['fresh-fcm']);
    expect(routes, ['/chat/room%2Fopen']);
    expect(harness.registrar.deletes, 1);
    await subscription.cancel();
    await harness.dispose();
  });

  test('initial message waits for session then navigates once', () async {
    final harness = await _service(initial: _message('pending-room'));
    final rooms = <String>[];
    final subscription = harness.service.opened.listen(
      (intent) => rooms.add(intent.roomId),
    );

    await _login();
    await SessionManager.instance.saveTokens(
      accessToken: 'access-2',
      refreshToken: 'refresh-2',
    );
    await _flush();

    expect(rooms, ['pending-room']);
    await subscription.cancel();
    await harness.dispose();
  });
}

Future<_Harness> _service({
  RemoteMessage? initial,
  LocalPushNotifications? localNotifications,
}) async {
  final foreground = StreamController<RemoteMessage>.broadcast();
  final opened = StreamController<RemoteMessage>.broadcast();
  final refresh = StreamController<String>.broadcast();
  final messaging = _Messaging('', initial: initial, refresh: refresh.stream);
  final registrar = _Registrar();
  final chat = ChatNotificationCoordinator(
    _Socket(),
    currentUserId: () => 'me',
  );
  final service = PushNotificationService(
    firebaseAvailable: true,
    messaging: messaging,
    registrar: registrar,
    chat: chat,
    foregroundMessages: foreground.stream,
    openedMessages: opened.stream,
    localNotifications: localNotifications,
  );
  await service.initialize();
  return _Harness(service, registrar, chat, foreground, opened, refresh);
}

RemoteMessage _message(String roomId, {String messageId = ''}) => RemoteMessage(
  data: {
    'type': 'notification',
    'key': 'NEW_MESSAGE',
    'notificationType': 'chat',
    'resourceId': roomId,
    'messageId': messageId,
    'params': '{"senderId":"other"}',
  },
  notification: const RemoteNotification(title: 'Sender', body: 'Hello'),
);

ChatMessageModel _socketMessage(String id, String roomId) => ChatMessageModel(
  id: id,
  roomId: roomId,
  sender: const ChatSenderModel(
    id: 'other',
    fullName: 'Sender',
    role: 'student',
  ),
  text: 'Hello',
  attachments: const [],
  messageType: 'text',
  deletedForEveryone: false,
);

Future<void> _login({String userId = 'user-1', String? userRole}) =>
    SessionManager.instance.saveSession(
      accessToken: 'access',
      refreshToken: 'refresh-token-must-not-be-sent',
      userId: userId,
      userRole: userRole,
    );

Future<void> _flush() => Future<void>.delayed(Duration.zero);

class _Messaging implements PushMessaging {
  _Messaging(this.token, {this.initial, Stream<String>? refresh})
    : _refresh = refresh ?? const Stream.empty();
  String token;
  final RemoteMessage? initial;
  final Stream<String> _refresh;

  @override
  Future<String?> getToken() async => token;
  @override
  Future<RemoteMessage?> getInitialMessage() async => initial;
  @override
  Stream<String> get tokenRefresh => _refresh;
  @override
  Future<void> requestPermission() async {}
}

class _TokenRepo implements DeviceTokenRepo {
  final registered = <DeviceTokenPayload>[];
  final deleted = <String>[];
  final operations = <String>[];
  @override
  Future<void> register(DeviceTokenPayload payload) async {
    registered.add(payload);
    operations.add('register:${payload.token}');
  }

  @override
  Future<void> delete({required String token}) async {
    deleted.add(token);
    operations.add('delete:$token');
  }
}

class _Registrar implements PushTokenRegistrar {
  final refreshed = <String>[];
  int deletes = 0;
  @override
  Future<void> registerCurrent() async {}
  @override
  Future<void> register(String token) async => refreshed.add(token);
  @override
  Future<void> deleteCurrent() async => deletes++;
}

class _LocalNotifications extends Fake implements LocalPushNotifications {
  final shown = <AppNotification>[];

  @override
  Future<void> initialize(ValueChanged<String> onPayload) async {}

  @override
  Future<String?> initialPayload() async => null;

  @override
  Future<void> showNotification(
    AppNotification notification, {
    bool playNudgeLocally = true,
    String? appState,
  }) async => shown.add(notification);
}

class _Socket extends SocketService {}

class _Harness {
  _Harness(
    this.service,
    this.registrar,
    this.chat,
    this.foreground,
    this.opened,
    this.refresh,
  );
  final PushNotificationService service;
  final _Registrar registrar;
  final ChatNotificationCoordinator chat;
  final StreamController<RemoteMessage> foreground, opened;
  final StreamController<String> refresh;

  Future<void> dispose() async {
    await service.dispose();
    await chat.dispose();
    await foreground.close();
    await opened.close();
    await refresh.close();
  }
}
