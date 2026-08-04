import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  test('drawer contains one Gulf lessons management destination', () {
    final drawer = SupervisorNavigationConfig.drawer(S());

    expect(
      drawer.where((item) => item.route == Routes.lessonsManagement),
      hasLength(1),
    );
  });
}
