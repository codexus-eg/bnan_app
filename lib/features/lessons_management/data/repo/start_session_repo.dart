import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';
import 'package:dartz/dartz.dart';

abstract class StartSessionRepo {
  Future<Either<Failure, StartSessionData>> startSession({
    required String classroomId,
    required String subjectId,
  });
}
