import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';

abstract final class IdealTeacherAccessPolicy {
  static bool get canAccessCurrent => canAccess(SessionManager.instance.role);

  static bool canAccess(UserRole? role) =>
      role == UserRole.supervisor || role == UserRole.admin;

  static bool canModify(UserRole? role) =>
      role == UserRole.supervisor || role == UserRole.admin;

  static bool canSelectTeachers(UserRole? role) =>
      role == UserRole.supervisor || role == UserRole.admin;

  static bool canIssueCertificate(UserRole? role) =>
      role == UserRole.supervisor || role == UserRole.admin;
}

