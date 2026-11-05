import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';
import 'package:dartz/dartz.dart';

abstract class StartSessionRepo {
  Future<Either<Failure, StartSessionData>> startSession({
    required String classroomId,
    required String subjectId,
    String? classroomSubjectId,
    String? lessonId,
    String? occurrenceDate,
    String? system,
  });

  Future<Either<Failure, StartSessionData?>> getActiveSession({
    required String classroomId,
  });

  Future<Either<Failure, String>> joinActiveSession({
    required String classroomId,
    String? weeklySlotKey,
  });

  Future<Either<Failure, String>> getTeacherEntry({
    required String classroomId,
    required String sessionId,
  });

  Future<Either<Failure, void>> endSession({required String sessionId});
}
