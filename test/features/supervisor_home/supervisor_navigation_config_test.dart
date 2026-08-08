import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
  });

  test('plans destination uses the existing supervisor plans route', () {
    final plans = SupervisorNavigationConfig.drawer(
      S(),
    ).firstWhere((item) => item.route == Routes.plans);

    expect(plans.extra, isNull);
  });

  test('attendance destinations use the attendance route', () {
    final drawer = SupervisorNavigationConfig.drawer(S());
    final bottom = SupervisorNavigationConfig.bottom(S());

    expect(
      drawer.where((item) => item.route == Routes.attendance),
      hasLength(1),
    );
    expect(
      bottom.where((item) => item.route == Routes.attendance),
      hasLength(1),
    );
  });

  test('Egyptian supervisor sees only the read-only schedule', () async {
    await _saveSupervisor(RegistrationMode.egyptian);
    final drawer = SupervisorNavigationConfig.drawer(S());

    expect(
      drawer.where((item) => item.route == Routes.egyptianSchedulesReadOnly),
      hasLength(1),
    );
    expect(
      drawer.where((item) => item.route == Routes.lessonsManagement),
      isEmpty,
    );
    expect(
      drawer.where((item) => item.route == Routes.weeklyIdealStudents),
      hasLength(1),
    );
  });

  test('Gulf supervisor sees only lessons management', () async {
    await _saveSupervisor(RegistrationMode.gulf);
    final drawer = SupervisorNavigationConfig.drawer(S());

    expect(
      drawer.where((item) => item.route == Routes.lessonsManagement),
      hasLength(1),
    );
    expect(
      drawer.where((item) => item.route == Routes.egyptianSchedulesReadOnly),
      isEmpty,
    );
    expect(
      drawer.where((item) => item.route == Routes.weeklyIdealStudents),
      isEmpty,
    );
  });

  test('supervisor without a mode sees neither schedule item', () async {
    await _saveSupervisor(null);
    final drawer = SupervisorNavigationConfig.drawer(S());

    expect(
      drawer.where(
        (item) =>
            item.route == Routes.egyptianSchedulesReadOnly ||
            item.route == Routes.lessonsManagement,
      ),
      isEmpty,
    );
    expect(
      drawer.where((item) => item.route == Routes.weeklyIdealStudents),
      isEmpty,
    );
  });
}

Future<void> _saveSupervisor(RegistrationMode? mode) {
  return SessionManager.instance.saveSession(
    accessToken: 'token',
    refreshToken: '',
    userRole: 'supervisor',
    registrationMode: mode,
  );
}
