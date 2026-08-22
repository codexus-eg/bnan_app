import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_availability_status.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/gulf_evaluation_classroom_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_value_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/repo/weekly_evaluations_read_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_state.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_weekly_evaluations_body.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_skeleton.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('initial loading reuses management skeleton', (tester) async {
    await _pump(
      tester,
      const ReadOnlyWeeklyEvaluationsState(
        role: ReadOnlyEvaluationsRole.student,
        status: ReadOnlyEvaluationsStatus.loading,
        isLoading: true,
      ),
    );
    expect(find.byType(WeeklyEvaluationsSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byKey(const Key('readOnlyWeekDropdown')), findsOneWidget);
    expect(find.byKey(const Key('readOnlyClassroomDropdown')), findsOneWidget);
  });

  testWidgets('parent without children has one empty state', (tester) async {
    await _pump(
      tester,
      const ReadOnlyWeeklyEvaluationsState(
        role: ReadOnlyEvaluationsRole.parent,
        status: ReadOnlyEvaluationsStatus.empty,
        hasLoadedChildren: true,
      ),
    );
    expect(find.text('No children are linked to this account'), findsOneWidget);
    expect(find.byKey(const Key('readOnlyChildDropdown')), findsOneWidget);
    expect(find.byKey(const Key('readOnlyWeekDropdown')), findsOneWidget);
    expect(find.byKey(const Key('readOnlyClassroomDropdown')), findsOneWidget);
  });

  testWidgets('one child keeps the parent dropdown layout', (tester) async {
    await _pump(tester, _parentState(children: const [_child1]));
    expect(find.byKey(const Key('readOnlySingleChild')), findsNothing);
    expect(find.byKey(const Key('readOnlyChildDropdown')), findsOneWidget);
  });

  testWidgets('multiple children have dropdown and selection calls cubit', (
    tester,
  ) async {
    final harness = await _pump(
      tester,
      _parentState(children: const [_child1, _child2]),
    );
    await tester.tap(find.byKey(const Key('readOnlyChildDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Child Two').last);
    await tester.pumpAndSettle();
    expect(harness.repo.calls.last.studentId, 'child-2');
    expect(harness.cubit.state.selectedChildId, 'child-2');
  });

  testWidgets('week dropdown stays visible until backend supplies a week', (
    tester,
  ) async {
    await _pump(tester, _studentState(_gulfData(), week: null));
    expect(find.byKey(const Key('readOnlyWeekDropdown')), findsOneWidget);
  });

  testWidgets('week dropdown keeps max week after selecting an older week', (
    tester,
  ) async {
    final harness = await _pump(tester, _studentState(_gulfData(), week: 2));
    await tester.tap(find.byKey(const Key('readOnlyWeekDropdown')));
    await tester.pumpAndSettle();
    expect(find.text('Week 1'), findsWidgets);
    expect(find.text('Week 2'), findsWidgets);
    expect(find.text('Week 3'), findsNothing);
    await tester.tap(find.text('Week 1').last);
    await tester.pumpAndSettle();
    expect(harness.cubit.state.selectedWeek, 1);
    expect(harness.cubit.state.maxAvailableWeek, 2);

    await tester.tap(find.byKey(const Key('readOnlyWeekDropdown')));
    await tester.pumpAndSettle();
    expect(find.text('Week 2'), findsWidgets);
    await tester.tap(find.text('Week 2').last);
    await tester.pumpAndSettle();
    expect(harness.repo.calls.last, (
      week: 2,
      studentId: null,
      classroomId: 'general',
    ));
  });

  testWidgets('week appears before classroom and both scopes stay combined', (
    tester,
  ) async {
    final state = _studentState(_gulfData(), week: 2).copyWith(
      classrooms: const [
        ReadEvaluationReferenceModel(id: 'general', name: 'General'),
        ReadEvaluationReferenceModel(id: 'arabic', name: 'Private Arabic'),
      ],
      selectedClassroomId: 'general',
    );
    final harness = await _pump(tester, state);
    final week = find.byKey(const Key('readOnlyWeekDropdown'));
    final classroom = find.byKey(const Key('readOnlyClassroomDropdown'));
    expect(
      tester.getTopLeft(week).dx,
      lessThan(tester.getTopLeft(classroom).dx),
    );

    await tester.tap(classroom);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Private Arabic').last);
    await tester.pumpAndSettle();
    expect(harness.repo.calls.last, (
      week: 2,
      studentId: null,
      classroomId: 'arabic',
    ));

    await tester.tap(week);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Week 1').last);
    await tester.pumpAndSettle();
    expect(harness.repo.calls.last, (
      week: 1,
      studentId: null,
      classroomId: 'arabic',
    ));
  });

  testWidgets('classroom dropdown never shows aggregate option', (
    tester,
  ) async {
    await _pump(tester, _studentState(_gulfData()));
    await tester.tap(find.byKey(const Key('readOnlyClassroomDropdown')));
    await tester.pumpAndSettle();
    expect(find.text('All Classrooms'), findsNothing);
  });

  testWidgets('gulf table shows subjects only and maps evaluated values', (
    tester,
  ) async {
    final data = _gulfData(
      count: 3,
      subjects: const [MeEvaluationSubjectModel(name: 'Do not render')],
    );
    await _pump(tester, _studentState(data));
    expect(find.byKey(const Key('readOnlyEvaluationTable')), findsOneWidget);
    expect(find.text('Physics'), findsOneWidget);
    expect(find.text('Subject 1'), findsOneWidget);
    expect(find.text('Subject 2'), findsOneWidget);
    expect(find.text('Classroom One'), findsNothing);
    expect(find.text('Grade Four'), findsNothing);
    expect(find.text('National'), findsNothing);
    expect(find.text('Present'), findsNWidgets(3));
    expect(find.text('Excellent'), findsWidgets);
    expect(find.text('Do not render'), findsNothing);
  });

  testWidgets('gulf not evaluated keeps subject row with empty cells', (
    tester,
  ) async {
    await _pump(
      tester,
      _studentState(
        _gulfData(status: EvaluationAvailabilityStatus.notEvaluated),
      ),
    );
    expect(find.text('Physics'), findsOneWidget);
    expect(find.text('-'), findsWidgets);
    expect(find.text('Classroom One'), findsNothing);
  });

  testWidgets('gulf unavailable without subject is omitted', (tester) async {
    await _pump(
      tester,
      _studentState(
        _gulfData(
          status: EvaluationAvailabilityStatus.notAvailable,
          withSubject: false,
        ),
      ),
    );
    expect(find.text('Classroom One'), findsNothing);
    expect(find.text('Physics'), findsNothing);
    expect(find.byKey(const Key('readOnlyEvaluationTable')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gulf unknown status with subject stays as a safe row', (
    tester,
  ) async {
    await _pump(
      tester,
      _studentState(_gulfData(status: EvaluationAvailabilityStatus.unknown)),
    );
    expect(find.text('Physics'), findsOneWidget);
    expect(find.text('-'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('70 gulf subjects render in one table without overflow', (
    tester,
  ) async {
    await _pump(tester, _studentState(_gulfData(count: 70)));
    expect(find.byKey(const Key('readOnlyEvaluationTable')), findsOneWidget);
    expect(find.text('Classroom 69'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('egyptian renderer uses the same table for every subject', (
    tester,
  ) async {
    await _pump(tester, _studentState(_egyptianData()));
    expect(find.byKey(const Key('readOnlyEvaluationTable')), findsOneWidget);
    expect(find.text('Math'), findsOneWidget);
    expect(find.text('Science'), findsOneWidget);
    expect(find.text('Egypt Class'), findsNothing);
    expect(find.text('Grade Four'), findsNothing);
    expect(find.text('National'), findsNothing);
    expect(find.text('-'), findsWidgets);
  });

  testWidgets('unknown mode chooses gulf when classrooms exist', (
    tester,
  ) async {
    await _pump(tester, _studentState(_gulfData(mode: EvaluationMode.unknown)));
    expect(find.byKey(const Key('gulfEvaluationsLazyList')), findsOneWidget);
  });

  testWidgets('unknown mode chooses egyptian when only subjects exist', (
    tester,
  ) async {
    await _pump(
      tester,
      _studentState(_egyptianData(mode: EvaluationMode.unknown)),
    );
    expect(
      find.byKey(const Key('egyptianEvaluationsLazyList')),
      findsOneWidget,
    );
  });

  for (final mode in [EvaluationMode.gulf, EvaluationMode.egyptian]) {
    testWidgets('empty $mode is centered and localized', (tester) async {
      final data = MeWeeklyEvaluationsDataModel(mode: mode, week: 1);
      await _pump(
        tester,
        _studentState(data, status: ReadOnlyEvaluationsStatus.empty),
      );
      expect(
        find.text(
          mode == EvaluationMode.gulf
              ? 'No classrooms available'
              : 'No subjects are available',
        ),
        findsOneWidget,
      );
    });
  }

  testWidgets('failure without data shows retry and invokes reload', (
    tester,
  ) async {
    final harness = await _pump(
      tester,
      const ReadOnlyWeeklyEvaluationsState(
        role: ReadOnlyEvaluationsRole.student,
        status: ReadOnlyEvaluationsStatus.failure,
        selectedWeek: 2,
        selectedClassroomId: 'general',
        classrooms: [
          ReadEvaluationReferenceModel(id: 'general', name: 'General'),
        ],
        failureMessage: 'Failed',
      ),
    );
    expect(find.text('Failed'), findsOneWidget);
    await tester.tap(find.byKey(const Key('readOnlyRetry')));
    await tester.pumpAndSettle();
    expect(harness.repo.calls.single, (
      week: 2,
      studentId: null,
      classroomId: 'general',
    ));
  });

  testWidgets('failure with previous data keeps content and inline error', (
    tester,
  ) async {
    await _pump(
      tester,
      _studentState(
        _gulfData(),
        status: ReadOnlyEvaluationsStatus.failure,
        failureMessage: 'Refresh failed',
      ),
    );
    expect(find.text('Physics'), findsOneWidget);
    expect(find.byKey(const Key('readOnlyInlineFailure')), findsOneWidget);
  });

  testWidgets('changing week replaces old data with management skeleton', (
    tester,
  ) async {
    await _pump(
      tester,
      _studentState(
        _gulfData(),
      ).copyWith(isLoading: true, isChangingWeek: true),
    );
    expect(find.byType(WeeklyEvaluationsSkeleton), findsOneWidget);
    expect(find.text('Physics'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(const Key('readOnlyWeekDropdown')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('changing classroom hides previous data', (tester) async {
    await _pump(
      tester,
      _studentState(
        _gulfData(),
      ).copyWith(isLoading: true, isChangingClassroom: true, data: null),
    );
    expect(find.byType(WeeklyEvaluationsSkeleton), findsOneWidget);
    expect(find.text('Physics'), findsNothing);
  });

  testWidgets('changing child keeps filters and uses management skeleton', (
    tester,
  ) async {
    await _pump(
      tester,
      _parentState(
        children: const [_child1, _child2],
      ).copyWith(isLoading: true, isChangingChild: true),
    );
    expect(find.byType(WeeklyEvaluationsSkeleton), findsOneWidget);
    expect(find.text('Physics'), findsNothing);
    expect(find.byKey(const Key('readOnlyChildDropdown')), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('read-only body never exposes add or edit controls', (
    tester,
  ) async {
    await _pump(tester, _studentState(_gulfData()));
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byIcon(Icons.edit), findsNothing);
  });

  testWidgets('small RTL layout has no overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(300, 520));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pump(
      tester,
      _parentState(
        children: const [_child1, _child2],
        data: _gulfData(longNames: true),
      ),
      locale: const Locale('ar'),
    );
    expect(find.byType(ReadOnlyWeeklyEvaluationsBody), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _child1 = ParentEvaluationChildModel(
  id: 'child-1',
  fullName: 'Child One',
  classrooms: [ReadEvaluationReferenceModel(id: 'class-1', name: 'Class One')],
);
const _child2 = ParentEvaluationChildModel(
  id: 'child-2',
  fullName: 'Child Two',
  classrooms: [ReadEvaluationReferenceModel(id: 'class-2', name: 'Class Two')],
);
const _evaluation = MeEvaluationValueModel(
  attendance: 'present',
  participation: 'excellent',
  homework: 'very_good',
  behavior: 'good',
  notes: 'Steady progress',
);

ReadOnlyWeeklyEvaluationsState _studentState(
  MeWeeklyEvaluationsDataModel data, {
  int? week = 1,
  ReadOnlyEvaluationsStatus status = ReadOnlyEvaluationsStatus.success,
  String? failureMessage,
}) => ReadOnlyWeeklyEvaluationsState(
  role: ReadOnlyEvaluationsRole.student,
  status: status,
  selectedWeek: week,
  maxAvailableWeek: week,
  classrooms: const [
    ReadEvaluationReferenceModel(id: 'general', name: 'General'),
  ],
  selectedClassroomId: 'general',
  data: data,
  failureMessage: failureMessage,
);

ReadOnlyWeeklyEvaluationsState _parentState({
  required List<ParentEvaluationChildModel> children,
  MeWeeklyEvaluationsDataModel? data,
}) => ReadOnlyWeeklyEvaluationsState(
  role: ReadOnlyEvaluationsRole.parent,
  status: ReadOnlyEvaluationsStatus.success,
  children: children,
  selectedChildId: children.first.id,
  classrooms: children.first.classrooms,
  selectedClassroomId: children.first.classrooms.first.id,
  selectedWeek: 2,
  maxAvailableWeek: 2,
  data: data ?? _gulfData(week: 2),
  hasLoadedChildren: true,
);

MeWeeklyEvaluationsDataModel _gulfData({
  EvaluationMode mode = EvaluationMode.gulf,
  EvaluationAvailabilityStatus status = EvaluationAvailabilityStatus.evaluated,
  int count = 1,
  int week = 1,
  bool withSubject = true,
  bool longNames = false,
  List<MeEvaluationSubjectModel> subjects = const [],
}) => MeWeeklyEvaluationsDataModel(
  mode: mode,
  week: week,
  subjects: subjects,
  classrooms: List.generate(
    count,
    (index) => GulfEvaluationClassroomModel(
      id: 'class-$index',
      name: index == 0
          ? longNames
                ? 'A very long classroom name that must stay inside the card'
                : 'Classroom One'
          : 'Classroom $index',
      subject: withSubject
          ? ReadEvaluationReferenceModel(
              id: 's$index',
              name: index == 0 ? 'Physics' : 'Subject $index',
            )
          : null,
      grade: const ReadEvaluationReferenceModel(id: 'g1', name: 'Grade Four'),
      curriculum: ReadEvaluationReferenceModel(
        id: 'c1',
        name: longNames
            ? 'A very long curriculum name that must use ellipsis safely'
            : 'National',
      ),
      evaluationStatus: status,
      evaluation: status == EvaluationAvailabilityStatus.evaluated
          ? _evaluation
          : null,
    ),
  ),
);

MeWeeklyEvaluationsDataModel _egyptianData({
  EvaluationMode mode = EvaluationMode.egyptian,
}) => MeWeeklyEvaluationsDataModel(
  mode: mode,
  week: 1,
  classroom: const ReadEvaluationReferenceModel(name: 'Egypt Class'),
  grade: const ReadEvaluationReferenceModel(name: 'Grade Four'),
  curriculum: const ReadEvaluationReferenceModel(name: 'National'),
  subjects: const [
    MeEvaluationSubjectModel(
      id: 'math',
      name: 'Math',
      status: 'evaluated',
      evaluation: _evaluation,
    ),
    MeEvaluationSubjectModel(
      id: 'science',
      name: 'Science',
      status: 'not_evaluated',
    ),
  ],
);

Future<({ReadOnlyWeeklyEvaluationsCubit cubit, _UiRepo repo})> _pump(
  WidgetTester tester,
  ReadOnlyWeeklyEvaluationsState state, {
  Locale locale = const Locale('en'),
}) async {
  final repo = _UiRepo();
  final cubit = _SeedCubit(repo)..seed(state);
  addTearDown(cubit.close);
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: BlocProvider<ReadOnlyWeeklyEvaluationsCubit>.value(
        value: cubit,
        child: const Scaffold(body: ReadOnlyWeeklyEvaluationsBody()),
      ),
    ),
  );
  await tester.pump();
  return (cubit: cubit, repo: repo);
}

class _SeedCubit extends ReadOnlyWeeklyEvaluationsCubit {
  _SeedCubit(super.repo);
  void seed(ReadOnlyWeeklyEvaluationsState value) => emit(value);
}

class _UiRepo implements WeeklyEvaluationsReadRepo {
  final calls = <({int? week, String? studentId, String? classroomId})>[];

  @override
  Future<Either<Failure, List<ParentEvaluationChildModel>>>
  getParentChildren() async => const Right([]);

  @override
  Future<Either<Failure, List<ReadEvaluationReferenceModel>>>
  getMyClassrooms() async => const Right([]);

  @override
  Future<Either<Failure, MeWeeklyEvaluationsResponseModel>> getMyEvaluations({
    int? week,
    String? studentId,
    String? classroomId,
  }) async {
    calls.add((week: week, studentId: studentId, classroomId: classroomId));
    return Right(
      MeWeeklyEvaluationsResponseModel(
        success: true,
        data: _gulfData(week: week ?? 1),
      ),
    );
  }
}
