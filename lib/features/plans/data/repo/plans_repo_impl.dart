import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/models/create_plan_response_model.dart';
import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PlansRepoImpl implements PlansRepo {
  const PlansRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, ParentChildrenResponseModel>> getParentChildren() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.parentChildren,
        isProtected: true,
      );
      return ParentChildrenResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, ParentChildrenPlansResponseModel>>
  getParentChildrenPlans() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.parentChildrenPlans,
        isProtected: true,
      );
      return ParentChildrenPlansResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, CreatePlanResponseModel>> uploadTermPlan({
    required String classroomId,
    required String subjectId,
    required String attachmentPath,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.post(
        EndPoints.createPlan(classroomId: classroomId, subjectId: subjectId),
        data: FormData.fromMap({
          'type': 'term',
          'attachment': await MultipartFile.fromFile(attachmentPath),
        }),
        isFormData: true,
        isProtected: true,
      );
      return CreatePlanResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, CreatePlanResponseModel>> createDailyPlan({
    required String classroomId,
    required String subjectId,
    required CreateDailyPlanRequestModel request,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.post(
        EndPoints.createPlan(classroomId: classroomId, subjectId: subjectId),
        data: request.toJson(),
        isProtected: true,
      );
      return CreatePlanResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, WeeklyPlansResponseModel>> getPlansByWeek({
    required String classroomId,
    required int week,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.plansByWeek(classroomId: classroomId, week: week),
        isProtected: true,
      );
      return WeeklyPlansResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, TermPlansResponseModel>> getTermPlans({
    required String classroomId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.termPlans(classroomId),
        isProtected: true,
      );
      return TermPlansResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, TermPlansResponseModel>> getAllTermPlans({
    String? classroomId,
  }) {
    return repoGuard(() async {
      final id = classroomId?.trim();
      final response = await apiConsumer.get(
        EndPoints.allTermPlans,
        queryParameter: {if (id != null && id.isNotEmpty) 'classroomId': id},
        isProtected: true,
      );
      return TermPlansResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, ElapsedWeeksResponseModel>> getElapsedWeeks({
    required String classroomId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.elapsedPlanWeeks(classroomId),
        isProtected: true,
      );
      return ElapsedWeeksResponseModel.fromJson(asMap(response));
    });
  }
}
