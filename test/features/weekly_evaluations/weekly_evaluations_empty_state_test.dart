import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.saveSession(
      accessToken: 'token',
      refreshToken: 'refresh',
      userRole: 'supervisor',
    );
  });
  tearDown(() => SessionManager.instance.clearSession());

  testWidgets('empty classrooms keeps actions and filters above no-data', (
    tester,
  ) async {
    final source = _SupervisorRepo.pending();
    final evaluations = _WeeklyRepo();
    await _pump(tester, source, evaluations);

    expect(find.byType(AppSkeletonizer), findsOneWidget);
    source.complete(const Right(GetSupervisorClassroomsResponseModel()));
    await tester.pumpAndSettle();

    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(find.byType(AppSkeletonizer), findsNothing);
    expect(find.byType(CustomDropdown), findsNWidgets(2));
    expect(find.text('Add New Evaluation'), findsOneWidget);
    expect(evaluations.weekCalls, 0);
    final filtersBottom = tester
        .getBottomRight(find.byType(CustomDropdown).last)
        .dy;
    expect(
      tester.getCenter(find.byType(NoDataWidget)).dy,
      greaterThan(filtersBottom),
    );
  });

  testWidgets('empty evaluations keep filters and show centered no-data', (
    tester,
  ) async {
    final source = _SupervisorRepo.ready();
    final evaluations = _WeeklyRepo();
    await _pump(tester, source, evaluations);
    await tester.pumpAndSettle();

    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(find.byType(CustomDropdown), findsNWidgets(2));
    expect(find.byType(AppSkeletonizer), findsNothing);
    expect(evaluations.weekCalls, 1);
    final filtersBottom = tester
        .getBottomRight(find.byType(CustomDropdown).last)
        .dy;
    expect(
      tester.getCenter(find.byType(NoDataWidget)).dy,
      greaterThan(filtersBottom),
    );
  });

  testWidgets('classrooms failure retries only the classrooms request', (
    tester,
  ) async {
    final source = _SupervisorRepo.failureThenEmpty();
    final evaluations = _WeeklyRepo();
    await _pump(tester, source, evaluations);
    await tester.pumpAndSettle();

    expect(find.text('Classrooms unavailable'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(source.calls, 2);
    expect(evaluations.weekCalls, 0);
    expect(find.byType(NoDataWidget), findsOneWidget);
  });
}

Future<void> _pump(
  WidgetTester tester,
  _SupervisorRepo source,
  _WeeklyRepo evaluations,
) async {
  final weekly = WeeklyEvaluationsCubit(evaluations, _AssignmentsRepo())
    ..initialize('supervisor');
  final classrooms = GetSupervisorClassroomsCubit(source)..getMyClassrooms();
  addTearDown(weekly.close);
  addTearDown(classrooms.close);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: weekly),
          BlocProvider.value(value: classrooms),
        ],
        child: Scaffold(
          body: WeeklyEvaluationsBody(
            policy: WeeklyEvaluationsAccessPolicy.fromRole('supervisor'),
          ),
        ),
      ),
    ),
  );
}

class _SupervisorRepo implements SupervisorManagementRepo {
  _SupervisorRepo(this.results) : gate = null;
  _SupervisorRepo.pending()
    : gate = Completer<Either<Failure, GetSupervisorClassroomsResponseModel>>(),
      results = [];
  _SupervisorRepo.ready()
    : this([
        const Right(
          GetSupervisorClassroomsResponseModel(
            data: [SupervisorClassroomModel(id: 'classroom', name: 'Class A')],
          ),
        ),
      ]);
  _SupervisorRepo.failureThenEmpty()
    : this([
        Left(Failure(message: 'Classrooms unavailable')),
        const Right(GetSupervisorClassroomsResponseModel()),
      ]);

  final List<Either<Failure, GetSupervisorClassroomsResponseModel>> results;
  final Completer<Either<Failure, GetSupervisorClassroomsResponseModel>>? gate;
  int calls = 0;

  void complete(Either<Failure, GetSupervisorClassroomsResponseModel> value) =>
      gate!.complete(value);

  @override
  Future<Either<Failure, GetSupervisorClassroomsResponseModel>>
  getMyClassrooms() {
    calls++;
    return gate?.future ?? Future.value(results.removeAt(0));
  }
}

class _WeeklyRepo implements WeeklyEvaluationsRepo {
  int weekCalls = 0;

  @override
  Future<Either<Failure, ElapsedEvaluationWeeksModel>> getElapsedWeeks(
    String classroomId,
  ) async => const Right(
    ElapsedEvaluationWeeksModel(
      data: ElapsedEvaluationWeeksData(weeksCount: 1, currentWeek: 1),
    ),
  );

  @override
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getClassroomWeekly({
    required String classroomId,
    required int week,
  }) async {
    weekCalls++;
    return const Right(
      WeeklyEvaluationsResponseModel(data: WeeklyEvaluationsDataModel()),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AssignmentsRepo implements AssignmentsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
