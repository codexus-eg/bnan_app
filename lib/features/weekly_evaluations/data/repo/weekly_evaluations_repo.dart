import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class WeeklyEvaluationsRepo {
  Future<Either<Failure, ElapsedEvaluationWeeksModel>> getElapsedWeeks(
    String classroomId,
  );
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getClassroomWeekly({
    required String classroomId,
    required int week,
  });
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getMyEvaluations({
    required int week,
    String? studentId,
  });
  Future<Either<Failure, ParentChildrenResponseModel>> getParentChildren();
  Future<Either<Failure, List<WeeklyEvaluationStudentModel>>>
  getClassroomStudents(String classroomId);
  Future<Either<Failure, List<EvaluationSubjectModel>>> getStudentSubjects({
    required String classroomId,
    required String studentId,
  });
  Future<Either<Failure, Unit>> upsert(UpsertEvaluationRequestModel request);
  Future<Either<Failure, Unit>> publishWeeklyEvaluations({
    required String classroomId,
    required int week,
  });
}
