import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';

abstract final class IdealStudentAccessPolicy {
  static bool get canAccessCurrent {
    final session = SessionManager.instance;
    return canAccess(
      role: session.role,
      registrationMode: session.registrationMode,
      registrationModes: session.registrationModes,
    );
  }

  static bool canAccess({
    required UserRole? role,
    required RegistrationMode? registrationMode,
    required List<RegistrationMode> registrationModes,
  }) => switch (role) {
    UserRole.teacher => registrationModes.contains(RegistrationMode.egyptian),
    UserRole.supervisor => registrationMode == RegistrationMode.egyptian,
    _ => false,
  };
}
