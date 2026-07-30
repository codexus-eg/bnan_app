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

  test('attendance destinations stay safely disabled', () {
    final disabledDrawer = SupervisorNavigationConfig.drawer(
      S(),
    ).where((item) => !item.isEnabled);
    final disabledBottom = SupervisorNavigationConfig.bottom(
      S(),
    ).where((item) => !item.isEnabled);

    expect(disabledDrawer.length, 2);
    expect(disabledBottom.length, 2);
  });
}
