import 'package:bnan_app/core/app_routes/home_route_resolver.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supervisor resolves to supervisor home', () {
    expect(HomeRouteResolver.forRole('supervisor'), Routes.supervisorHome);
  });

  test('role resolver keeps existing home mappings', () {
    expect(HomeRouteResolver.forRole('student'), Routes.home);
    expect(HomeRouteResolver.forRole('teacher'), Routes.teacherHome);
    expect(HomeRouteResolver.forRole('admin'), Routes.adminHome);
    expect(HomeRouteResolver.forRole('parent'), Routes.parentHome);
    expect(HomeRouteResolver.forRole('unknown'), isNull);
  });
}
