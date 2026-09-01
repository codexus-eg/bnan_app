import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  test('deduplicates IDs with bounded cache', () {
    final recent = RecentNotificationIds(capacity: 2);
    expect(recent.claim('n1'), isTrue);
    expect(recent.claim('n1'), isFalse);
    recent.claim('n2');
    recent.claim('n3');
    expect(recent.claim('n1'), isTrue);
  });

  test('resolves chat and safely falls back for unknown screen', () async {
    await _saveRole(UserRole.student);
    final service = NotificationNavigationService(SessionManager.instance);
    expect(
      service.resolve(_value('chat_room', id: 'room/1')),
      '/chat/room%2F1',
    );
    expect(service.resolve(_value('future_screen')), Routes.home);
  });

  test('global key routes by broadcastId without notificationId', () async {
    final service = NotificationNavigationService(SessionManager.instance);
    final notification = AppNotification.fromJson({
      'key': 'GLOBAL_NOTIFICATION',
      'broadcastId': 'broadcast/1',
      'type': 'announcement',
    });

    final destination = await service.resolveDestination(notification);

    expect(destination.path, '/global_notification_details/broadcast%2F1');
    expect(destination.extra, same(notification));
  });

  test('announcement type alone keeps existing fallback flow', () async {
    await _saveRole(UserRole.student);
    final service = NotificationNavigationService(SessionManager.instance);
    final notification = AppNotification.fromJson({
      'key': 'PLATFORM_ANNOUNCEMENT',
      'type': 'announcement',
    });

    expect(await service.resolveDestination(notification), isNotNull);
    expect(service.resolve(notification), Routes.home);
  });

  for (final entry in const {
    UserRole.student: (screen: 'teacher_approval', home: Routes.home),
    UserRole.parent: (screen: 'performance', home: Routes.parentHome),
    UserRole.teacher: (screen: 'students', home: Routes.teacherHome),
    UserRole.supervisor: (
      screen: 'registration_requests',
      home: Routes.supervisorHome,
    ),
    UserRole.admin: (screen: 'subscription', home: Routes.adminHome),
  }.entries) {
    test('${entry.key.name} rejects another role notification route', () async {
      await _saveRole(entry.key);
      final service = NotificationNavigationService(SessionManager.instance);

      expect(service.resolve(_value(entry.value.screen)), entry.value.home);
    });
  }
}

Future<void> _saveRole(UserRole role) => SessionManager.instance.saveSession(
  accessToken: 'token',
  refreshToken: '',
  userRole: role.name,
);

AppNotification _value(String screen, {String? id}) =>
    AppNotification.fromJson({
      'id': 'n1',
      'key': 'ANY',
      'resource': {'id': id},
      'navigation': {'screen': screen},
    });
