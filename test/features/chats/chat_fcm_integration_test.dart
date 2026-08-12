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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    await CacheHelper.init();
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
      expect(repo.deleted, ['fcm-2']);
    },
  );

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

Future<_Harness> _service({RemoteMessage? initial}) async {
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

Future<void> _login() => SessionManager.instance.saveSession(
  accessToken: 'access',
  refreshToken: 'refresh-token-must-not-be-sent',
  userId: 'user-1',
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
  @override
  Future<void> register(DeviceTokenPayload payload) async =>
      registered.add(payload);
  @override
  Future<void> delete({required String token}) async => deleted.add(token);
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
