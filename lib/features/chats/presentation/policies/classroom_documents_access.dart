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
    final normalized = roomType?.trim().toLowerCase();
    final isClassroom = normalized == 'classroom' ||
        (classroomId?.trim().isNotEmpty == true &&
            (normalized == null || normalized.isEmpty));
    return isClassroom &&
        classroomId?.trim().isNotEmpty == true &&
        UserRole.fromValue(role) != null;
  }
}
