import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/models/create_plan_response_model.dart';
import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/repo/plans_repo.dart';
import 'package:dartz/dartz.dart';

class FakePlansRepo implements PlansRepo {
  final weekly = <Completer<Either<Failure, WeeklyPlansResponseModel>>>[];
  final term = <Completer<Either<Failure, TermPlansResponseModel>>>[];
  final elapsed = <Completer<Either<Failure, ElapsedWeeksResponseModel>>>[];
  final daily = <Completer<Either<Failure, CreatePlanResponseModel>>>[];
  final upload = <Completer<Either<Failure, CreatePlanResponseModel>>>[];
  int dailyCalls = 0;
  int uploadCalls = 0;

  @override
  Future<Either<Failure, WeeklyPlansResponseModel>> getPlansByWeek({
    required String classroomId,
    required int week,
  }) => weekly.removeAt(0).future;

  @override
  Future<Either<Failure, TermPlansResponseModel>> getTermPlans({
    required String classroomId,
  }) => term.removeAt(0).future;

  @override
  Future<Either<Failure, ElapsedWeeksResponseModel>> getElapsedWeeks({
    required String classroomId,
  }) => elapsed.removeAt(0).future;

  @override
  Future<Either<Failure, CreatePlanResponseModel>> createDailyPlan({
    required String classroomId,
    required String subjectId,
    required CreateDailyPlanRequestModel request,
  }) {
    dailyCalls++;
    return daily.removeAt(0).future;
  }

  @override
  Future<Either<Failure, CreatePlanResponseModel>> uploadTermPlan({
    required String classroomId,
    required String subjectId,
    required String attachmentPath,
  }) {
    uploadCalls++;
    return upload.removeAt(0).future;
  }
}
