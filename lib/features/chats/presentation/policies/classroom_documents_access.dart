import 'package:bnan_app/core/enums/user_role.dart';

class ClassroomDocumentsAccess {
  const ClassroomDocumentsAccess._();

  static bool canMessages({
    required String? roomType,
    required String roomId,
    required String? role,
  }) {
    return roomType == 'classroom' &&
        roomId.trim().isNotEmpty &&
        UserRole.fromValue(role) != null;
  }

  static bool canRecordingsAndReports({
    required String? roomType,
    required String? classroomId,
    required String? role,
  }) {
    return roomType == 'classroom' &&
        classroomId?.trim().isNotEmpty == true &&
        UserRole.fromValue(role) != null;
  }
}
