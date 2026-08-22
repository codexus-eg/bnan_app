import 'package:bnan_app/core/enums/user_role.dart';

abstract final class ChangeRequestAccessPolicy {
  static bool canShow({
    required UserRole? role,
    required String? roomType,
    String? accessScope,
    String? classroomSubjectId,
    bool? canRequestTeacherWithdrawal,
    bool? classroomSubjectAmbiguous,
  }) {
    final type = roomType?.trim().toLowerCase();
    final scope = accessScope?.trim().toLowerCase();
    final hasSubject = classroomSubjectId?.trim().isNotEmpty == true;
    if (role == UserRole.student) {
      return type == 'classroom' && scope == 'private' && hasSubject;
    }
    if (role == UserRole.teacher) {
      return type == 'classroom' &&
          scope != null &&
          scope != 'shared_group' &&
          canRequestTeacherWithdrawal == true &&
          classroomSubjectAmbiguous == false;
    }
    return false;
  }
}
