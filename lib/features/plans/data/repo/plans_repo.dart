import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/models/create_plan_response_model.dart';
import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class PlansRepo {
  Future<Either<Failure, CreatePlanResponseModel>> uploadTermPlan({
    required String classroomId,
    required String subjectId,
    required String attachmentPath,
  });

  Future<Either<Failure, CreatePlanResponseModel>> createDailyPlan({
    required String classroomId,
    required String subjectId,
    required CreateDailyPlanRequestModel request,
  });

  Future<Either<Failure, WeeklyPlansResponseModel>> getPlansByWeek({
    required String classroomId,
    required int week,
  });

  Future<Either<Failure, TermPlansResponseModel>> getTermPlans({
    required String classroomId,
  });

  Future<Either<Failure, ElapsedWeeksResponseModel>> getElapsedWeeks({
    required String classroomId,
  });
}
