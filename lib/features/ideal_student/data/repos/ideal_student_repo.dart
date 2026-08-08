import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_ranking_response.dart';
import 'package:dartz/dartz.dart';

abstract class IdealStudentRepo {
  Future<Either<Failure, IdealStudentRankingResponse>> getWeeklyRanking({
    required String classroomId,
    required int page,
    required int limit,
  });
}
