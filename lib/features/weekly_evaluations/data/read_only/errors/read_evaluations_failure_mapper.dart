import 'package:bnan_app/generated/l10n.dart';

abstract final class ReadEvaluationsFailureMapper {
  static const gulfConflictCode = 'GULF_CLASSROOM_SUBJECT_DATA_CONFLICT';

  static String map({required String message, String? code, int? statusCode}) {
    final normalizedMessage = message.trim().toLowerCase();
    final normalizedCode = code?.trim().toUpperCase();
    if (normalizedMessage.contains('access denied')) {
      return S.current.weeklyEvaluationsStudentAccessDenied;
    }
    final hasGulfCode =
        normalizedCode == gulfConflictCode ||
        message.toUpperCase().contains(gulfConflictCode);
    if (hasGulfCode && (statusCode == null || statusCode == 409)) {
      return S.current.weeklyEvaluationsGulfClassroomConflict;
    }
    return message;
  }
}
