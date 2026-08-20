import 'package:bnan_app/core/enums/user_role.dart';

abstract final class ChangeRequestAccessPolicy {
  static bool canShow({
    required UserRole? role,
    required String? roomType,
    String? accessScope,
    bool canRequestTeacherWithdrawal = false,
  }) {
    final type = roomType?.trim().toLowerCase();
    if (role == UserRole.student) {
      return type == 'classroom' &&
          accessScope?.trim().toLowerCase() == 'private';
    }
    if (role == UserRole.teacher) {
      return type == 'classroom' && canRequestTeacherWithdrawal;
    }
    return false;
  }
}
