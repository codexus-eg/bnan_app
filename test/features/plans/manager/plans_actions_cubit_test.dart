import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/models/create_plan_response_model.dart';
import 'package:bnan_app/features/plans/presentation/manager/plans_actions/plans_actions_cubit.dart';
import 'package:bnan_app/features/plans/presentation/mappers/add_plan_error_message_mapper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_plans_repo.dart';

void main() {
  test(
    'actions prevent duplicate submits but allow different actions',
    () async {
      final repo = FakePlansRepo();
      final daily = Completer<Either<Failure, CreatePlanResponseModel>>();
      final upload = Completer<Either<Failure, CreatePlanResponseModel>>();
      repo.daily.add(daily);
      repo.upload.add(upload);
      final cubit = PlansActionsCubit(repo);
      const request = CreateDailyPlanRequestModel(
        day: '2026-07-29',
        sessionContent: 'lesson',
        sessionAssignment: 'homework',
      );

      final dailyCall = cubit.createDailyPlan(
        classroomId: 'classroom',
        subjectId: 'subject',
        request: request,
      );
      await cubit.createDailyPlan(
        classroomId: 'classroom',
        subjectId: 'subject',
        request: request,
      );
      final uploadCall = cubit.uploadTermPlan(
        classroomId: 'classroom',
        subjectId: 'subject',
        attachmentPath: 'plan.pdf',
      );
      await cubit.uploadTermPlan(
        classroomId: 'classroom',
        subjectId: 'subject',
        attachmentPath: 'plan.pdf',
      );

      expect(repo.dailyCalls, 1);
      expect(repo.uploadCalls, 1);
      daily.complete(const Right(CreatePlanResponseModel()));
      upload.complete(const Right(CreatePlanResponseModel()));
      await Future.wait([dailyCall, uploadCall]);
      await cubit.close();
    },
  );

  test('plans mapper changes only the trimmed duplicate message', () {
    expect(
      mapAddPlanErrorMessage(
        '  قيمة مكررة  ',
        duplicateMessage: 'Friendly duplicate',
      ),
      'Friendly duplicate',
    );
    expect(
      mapAddPlanErrorMessage(
        'Original API error',
        duplicateMessage: 'Friendly duplicate',
      ),
      'Original API error',
    );
  });
}
