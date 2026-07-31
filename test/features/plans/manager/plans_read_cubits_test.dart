import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_elapsed_weeks/get_elapsed_weeks_state.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_state.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_weekly_plans/get_weekly_plans_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_plans_repo.dart';

void main() {
  test('weekly cubit ignores an older response', () async {
    final repo = FakePlansRepo();
    final first = Completer<Either<Failure, WeeklyPlansResponseModel>>();
    final second = Completer<Either<Failure, WeeklyPlansResponseModel>>();
    repo.weekly.addAll([first, second]);
    final cubit = GetWeeklyPlansCubit(repo);

    final oldRequest = cubit.getPlansByWeek(classroomId: 'a', week: 1);
    final newRequest = cubit.getPlansByWeek(classroomId: 'b', week: 2);
    second.complete(const Right(WeeklyPlansResponseModel()));
    await newRequest;
    first.complete(Left(Failure(message: 'stale')));
    await oldRequest;

    expect(cubit.state, isA<GetWeeklyPlansSuccess>());
    await cubit.close();
  });

  test('term and elapsed cubits emit success', () async {
    final repo = FakePlansRepo();
    repo.term.add(Completer()..complete(const Right(TermPlansResponseModel())));
    repo.elapsed.add(
      Completer()..complete(const Right(ElapsedWeeksResponseModel())),
    );
    final termCubit = GetTermPlansCubit(repo);
    final elapsedCubit = GetElapsedWeeksCubit(repo);

    await termCubit.getTermPlans(classroomId: 'classroom');
    await elapsedCubit.getElapsedWeeks(classroomId: 'classroom');

    expect(termCubit.state, isA<GetTermPlansSuccess>());
    expect(elapsedCubit.state, isA<GetElapsedWeeksSuccess>());
    await termCubit.close();
    await elapsedCubit.close();
  });
}
