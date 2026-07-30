import 'package:bnan_app/core/app_routes/routes.dart';

abstract class HomeRouteResolver {
  static String? forRole(String? role) {
    return switch (role?.trim().toLowerCase()) {
      'student' => Routes.home,
      'teacher' => Routes.teacherHome,
      'admin' => Routes.adminHome,
      'supervisor' => Routes.supervisorHome,
      _ => null,
    };
  }
}
