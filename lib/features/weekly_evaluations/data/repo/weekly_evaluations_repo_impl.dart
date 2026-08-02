import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo.dart';
import 'package:dartz/dartz.dart';

class WeeklyEvaluationsRepoImpl implements WeeklyEvaluationsRepo {
  const WeeklyEvaluationsRepoImpl(this.apiConsumer);
  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, ElapsedEvaluationWeeksModel>> getElapsedWeeks(
    String classroomId,
  ) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.elapsedEvaluationWeeks(classroomId),
      isProtected: true,
    );
    return ElapsedEvaluationWeeksModel.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getClassroomWeekly({
    required String classroomId,
    required int week,
  }) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.classroomWeeklyEvaluations(classroomId),
      queryParameter: {'week': week},
      isProtected: true,
    );
    return WeeklyEvaluationsResponseModel.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getMyEvaluations({
    required int week,
    String? studentId,
  }) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.myEvaluations,
      queryParameter: {
        'week': week,
        if (studentId != null && studentId.isNotEmpty) 'studentId': studentId,
      },
      isProtected: true,
    );
    return WeeklyEvaluationsResponseModel.fromJson(asMap(response));
  });

  @override
  Future<Either<Failure, ParentChildrenResponseModel>> getParentChildren() =>
      repoGuard(() async {
        final response = await apiConsumer.get(
          EndPoints.parentChildren,
          isProtected: true,
        );
        return ParentChildrenResponseModel.fromJson(asMap(response));
      });

  @override
  Future<Either<Failure, List<WeeklyEvaluationStudentModel>>>
  getClassroomStudents(String classroomId) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.classroomStudents(classroomId),
      isProtected: true,
    );
    return EvaluationJsonParser.maps(
      asMap(response)['data'],
    ).map(WeeklyEvaluationStudentModel.fromJson).toList();
  });

  @override
  Future<Either<Failure, List<EvaluationSubjectModel>>> getStudentSubjects({
    required String classroomId,
    required String studentId,
  }) {
    final id = studentId.trim();
    if (id.isEmpty) {
      return Future.value(
        Left(Failure(message: 'Student ID is required to load subjects')),
      );
    }
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.studentSubjects(classroomId: classroomId, studentId: id),
        isProtected: true,
      );
      return EvaluationJsonParser.maps(
        asMap(response)['data'],
      ).map(EvaluationSubjectModel.fromJson).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> upsert(UpsertEvaluationRequestModel request) =>
      repoGuard(() async {
        await apiConsumer.put(
          EndPoints.studentEvaluations,
          data: request.toJson(),
          isProtected: true,
        );
        return unit;
      });
}
