import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';

abstract final class ChangeRequestAccessPolicy {
  static bool canShow({required UserRole? role, required String? roomType}) {
    final session = SessionManager.instance;
    final type = roomType?.trim().toLowerCase();
    if (role == UserRole.student) {
      return session.isGulfStudent ||
          (session.isEgyptianStudent && type == 'classroom');
    }
    if (role == UserRole.teacher) {
      return session.registrationModes.contains(RegistrationMode.gulf) ||
          type == 'classroom';
    }
    return false;
  }
}
