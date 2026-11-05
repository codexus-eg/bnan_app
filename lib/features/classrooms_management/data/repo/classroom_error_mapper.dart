import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/generated/l10n.dart';

Failure mapClassroomFailure(AppException error) {
  final code = error.code?.trim() ?? '';
  final msg = error.message.trim();
  final target = '$code $msg';

  if (target.contains('CLASSROOM_HAS_ACTIVE_SESSION')) {
    return Failure(
      message: S.current.classroomHasActiveSession,
      statusCode: 409,
      code: 'CLASSROOM_HAS_ACTIVE_SESSION',
    );
  }
  if (target.contains('CLASSROOM_SUBJECT_HAS_SCHEDULED_LESSONS')) {
    return Failure(
      message: S.current.classroomSubjectHasScheduledLessons,
      statusCode: 409,
      code: 'CLASSROOM_SUBJECT_HAS_SCHEDULED_LESSONS',
    );
  }
  if (target.contains('GRADE_ALREADY_IN_SHARED_CLASSROOM')) {
    return Failure(
      message: S.current.gradeAlreadyInSharedClassroom,
      statusCode: 409,
      code: 'GRADE_ALREADY_IN_SHARED_CLASSROOM',
    );
  }
  if (target.contains('SUBJECT_ALREADY_ASSIGNED_TO_CLASSROOM')) {
    return Failure(
      message: S.current.subjectAlreadyAssignedToClassroom,
      statusCode: 409,
      code: 'SUBJECT_ALREADY_ASSIGNED_TO_CLASSROOM',
    );
  }
  if (target.contains('SHARED_CLASSROOM_TARGETS_REQUIRED')) {
    return Failure(
      message: S.current.sharedClassroomTargetsRequired,
      statusCode: 400,
      code: 'SHARED_CLASSROOM_TARGETS_REQUIRED',
    );
  }
  if (target.contains('SHARED_CLASSROOM_REQUIRES_TWO_TARGETS')) {
    return Failure(
      message: S.current.sharedClassroomRequiresTwoTargets,
      statusCode: 400,
      code: 'SHARED_CLASSROOM_REQUIRES_TWO_TARGETS',
    );
  }
  if (target.contains('SHARED_CLASSROOM_PRIMARY_TARGET_REQUIRED')) {
    return Failure(
      message: S.current.sharedClassroomPrimaryTargetRequired,
      statusCode: 400,
      code: 'SHARED_CLASSROOM_PRIMARY_TARGET_REQUIRED',
    );
  }
  if (target.contains('SHARED_CLASSROOM_EGYPTIAN_ONLY')) {
    return Failure(
      message: S.current.sharedClassroomEgyptianOnly,
      statusCode: 400,
      code: 'SHARED_CLASSROOM_EGYPTIAN_ONLY',
    );
  }
  if (target.contains('SUBJECT_NOT_ALLOWED_FOR_SHARED_CLASSROOM')) {
    return Failure(
      message: S.current.subjectNotAllowedForSharedClassroom,
      statusCode: 400,
      code: 'SUBJECT_NOT_ALLOWED_FOR_SHARED_CLASSROOM',
    );
  }
  if (target.contains('DUPLICATE_SHARED_CLASSROOM_SUBJECT')) {
    return Failure(
      message: S.current.duplicateSharedClassroomSubject,
      statusCode: 400,
      code: 'DUPLICATE_SHARED_CLASSROOM_SUBJECT',
    );
  }
  return Failure(
    message: error.message,
    statusCode: error.statusCode,
    code: error.code,
  );
}
