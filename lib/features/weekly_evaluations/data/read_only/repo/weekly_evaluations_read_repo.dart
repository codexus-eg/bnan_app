import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';
import 'package:dartz/dartz.dart';

abstract class WeeklyEvaluationsReadRepo {
  Future<Either<Failure, MeWeeklyEvaluationsResponseModel>> getMyEvaluations({
    int? week,
    String? studentId,
    String? classroomId,
  });

  Future<Either<Failure, List<ParentEvaluationChildModel>>> getParentChildren();

  Future<Either<Failure, List<ReadEvaluationReferenceModel>>> getMyClassrooms();
}
