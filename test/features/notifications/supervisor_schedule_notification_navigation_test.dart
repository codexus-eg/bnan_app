import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  for (final entry in const {
    RegistrationMode.egyptian: Routes.tablesManagement,
    RegistrationMode.gulf: Routes.lessonsManagement,
  }.entries) {
    test('${entry.key.name} supervisor opens its current schedule', () async {
      await SessionManager.instance.saveSession(
        accessToken: 'token',
        refreshToken: '',
        userRole: 'supervisor',
        registrationMode: entry.key,
      );
      final service = NotificationNavigationService(SessionManager.instance);

      expect(service.resolve(_schedule), entry.value);
    });
  }
}

final _schedule = AppNotification.fromJson({
  'id': 'schedule-notification',
  'key': 'ANY',
  'navigation': {'screen': 'schedule'},
});
