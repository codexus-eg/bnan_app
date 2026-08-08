import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/custom_table/custom_table_cell.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_value_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_dialog_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_editor_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/dialogs/weekly_evaluation_dialog.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_subject_actions.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table_row.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_card.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_form.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_filters.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_failure.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_header_actions.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

void main() {
  test('student and parent are read only while teacher can manage', () {
    expect(WeeklyEvaluationsAccessPolicy.fromRole('teacher').canEdit, isTrue);
    expect(WeeklyEvaluationsAccessPolicy.fromRole('supervisor').canAdd, isTrue);
    expect(WeeklyEvaluationsAccessPolicy.fromRole('student').canEdit, isFalse);
    expect(WeeklyEvaluationsAccessPolicy.fromRole('parent').canAdd, isFalse);
  });

  testWidgets('table renders behavior before notes without narrow overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pump(
      tester,
      const WeeklyEvaluationTable(
        subjects: [
          WeeklyEvaluationSubjectUiModel(
            subjectName: 'Math',
            attendance: 'Present',
            participation: 'Good',
            homework: 'Good',
            behavior: 'Excellent',
            notes: 'Progress',
          ),
        ],
      ),
    );

    final behaviorX = tester.getTopLeft(find.text('Behavior')).dx;
    final notesX = tester.getTopLeft(find.text('Notes')).dx;
    expect(behaviorX, lessThan(notesX));
    expect(tester.takeException(), isNull);
  });

  testWidgets('long dropdown value stays inside its field', (tester) async {
    const name = 'Gulf Test Student - English';
    await _pump(
      tester,
      Center(
        child: SizedBox(
          width: 160,
          child: CustomDropdown(
            label: 'Classroom',
            value: 'classroom',
            items: const ['classroom'],
            itemsLabels: const {'classroom': name},
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final textRect = tester.getRect(find.text(name).hitTestable());
    final fieldRect = tester.getRect(find.byType(DropdownButton<String>));
    expect(textRect.top, greaterThanOrEqualTo(fieldRect.top));
    expect(textRect.bottom, lessThanOrEqualTo(fieldRect.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('long notes wrap without clipping and keep equal row heights', (
    tester,
  ) async {
    const notes = '12345678901234567890123456789012345678901234567890';
    await _pump(
      tester,
      const WeeklyEvaluationTable(
        subjects: [
          WeeklyEvaluationSubjectUiModel(
            subjectName: 'Math',
            attendance: 'Present',
            participation: 'Excellent',
            homework: 'Excellent',
            behavior: 'Excellent',
            notes: notes,
          ),
        ],
      ),
    );

    final row = find.byType(WeeklyEvaluationTableRow);
    final cells = find.descendant(
      of: row,
      matching: find.byType(CustomTableCell),
    );
    final heights = cells.evaluate().map(
      (item) => (item.renderObject! as RenderBox).size.height,
    );
    expect(heights.toSet(), hasLength(1));
    expect(heights.first, greaterThan(42));
    final notesText = tester.widget<Text>(find.text(notes));
    expect(notesText.maxLines, isNull);
    expect(notesText.overflow, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('add action is compact and edit action is subject-specific', (
    tester,
  ) async {
    await _pump(
      tester,
      Column(
        children: [
          const WeeklyEvaluationsHeaderActions(),
          WeeklyEvaluationSubjectActions(
            subjects: const [
              EvaluationSubjectModel(id: 'a', name: 'Math'),
              EvaluationSubjectModel(
                id: 'b',
                name: 'Physics',
                status: 'evaluated',
                evaluation: EvaluationValueModel(attendance: 'present'),
              ),
            ],
            onPressed: (_) {},
          ),
        ],
      ),
    );

    expect(find.text('Add New Evaluation'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(
      tester.getSize(find.text('Add New Evaluation')).width,
      lessThan(tester.getSize(find.byType(Column).first).width),
    );
  });

  testWidgets('student without subjects has compact no-data and no table', (
    tester,
  ) async {
    await _pump(
      tester,
      const WeeklyEvaluationCard(
        evaluation: WeeklyEvaluationUiModel(
          id: 'student',
          title: 'Student: No Subjects',
          subjects: [],
        ),
      ),
    );

    expect(find.text('No evaluation for this student'), findsOneWidget);
    expect(find.byType(WeeklyEvaluationTable), findsNothing);
  });

  testWidgets('add form uses a numeric week and keeps single options enabled', (
    tester,
  ) async {
    await _pumpForm(
      tester,
      const EvaluationDialogContext.add(
        week: 2,
        classrooms: [PlanClassroomOption(id: 'classroom', name: 'Class A')],
      ),
    );

    expect(find.text('Week Start'), findsNothing);
    final week = _dropdownByLabel(tester, 'Week');
    expect(week.value, '2');
    expect(week.items, ['1', '2', '3']);
    expect(week.itemsLabels, {'1': 'Week 1', '2': 'Week 2', '3': 'Week 3'});
    final classroom = tester.widget<CustomDropdown>(
      find.byWidgetPredicate(
        (widget) => widget is CustomDropdown && widget.label == 'Classroom',
      ),
    );
    expect(classroom.value, isNull);
    expect(classroom.items, ['classroom']);
    expect(classroom.onChanged, isNotNull);
    final attendance = _dropdownByLabel(tester, 'Attendance');
    final participation = _dropdownByLabel(tester, 'Participation');
    final homework = _dropdownByLabel(tester, 'Homework');
    final behavior = _dropdownByLabel(tester, 'Behavior');
    expect(attendance.value, 'present');
    expect(attendance.items, ['present', 'absent', 'late', 'excused']);
    expect(attendance.itemsLabels?['excused'], 'Excused');
    expect(participation.value, 'excellent');
    expect(participation.items, [
      'excellent',
      'very_good',
      'good',
      'acceptable',
      'weak',
      '-',
    ]);
    expect(participation.itemsLabels?['very_good'], 'Very Good');
    expect(homework.items, participation.items);
    expect(behavior.items, participation.items);
    expect(homework.value, 'excellent');
    expect(behavior.value, 'excellent');
    expect(attendance.itemsLabels?['present'], 'Present');
    expect(participation.itemsLabels?['excellent'], 'Excellent');
    expect(
      find.byWidgetPredicate(
        (widget) => widget is CustomDropdown && widget.label == 'student',
        skipOffstage: false,
      ),
      findsOneWidget,
    );
  });

  testWidgets('edit form pre-fills behavior from current evaluation', (
    tester,
  ) async {
    await _pumpForm(
      tester,
      EvaluationDialogContext.edit(
        const EvaluationEditorContext(
          studentId: 'student',
          studentName: 'Student',
          classroomId: 'classroom',
          classroomName: 'Class A',
          week: 2,
          subject: _evaluatedSubject,
        ),
      ),
    );

    final behavior = tester.widget<CustomDropdown>(
      find.byWidgetPredicate(
        (widget) => widget is CustomDropdown && widget.label == 'Behavior',
      ),
    );
    expect(behavior.value, 'very_good');
    final bonus = tester.widget<CustomTextField>(
      find.byWidgetPredicate(
        (widget) => widget is CustomTextField && widget.label == 'Bonus Points',
      ),
    );
    expect(bonus.controller?.text, '4');
  });

  testWidgets('bonus rejects values outside zero to five', (tester) async {
    await _pumpForm(
      tester,
      EvaluationDialogContext.edit(
        const EvaluationEditorContext(
          studentId: 'student',
          studentName: 'Student',
          classroomId: 'classroom',
          classroomName: 'Class A',
          week: 2,
          subject: _evaluatedSubject,
        ),
      ),
    );
    final field = find.byWidgetPredicate(
      (widget) => widget is CustomTextField && widget.label == 'Bonus Points',
    );
    await tester.enterText(field, '6');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Bonus points must be from 0 to 5'), findsOneWidget);
  });

  testWidgets('first evaluation loads one student and one subject', (
    tester,
  ) async {
    final lookupRepo = _LookupRepo();
    await _pumpForm(
      tester,
      const EvaluationDialogContext.add(
        week: 2,
        classrooms: [PlanClassroomOption(id: 'classroom', name: 'Class A')],
      ),
      repo: lookupRepo,
    );

    _dropdownWithItem(tester, 'classroom').onChanged!('classroom');
    await tester.pumpAndSettle();
    final student = _dropdownWithItem(tester, 'student');
    expect(student.value, isNull);
    expect(student.onChanged, isNotNull);

    student.onChanged!('student');
    await tester.pumpAndSettle();
    expect(lookupRepo.subjectCalls, 1);
    final subject = _dropdownWithItem(tester, 'subject');
    expect(subject.value, isNull);
    expect(subject.onChanged, isNotNull);
  });

  testWidgets('evaluation failure shows its message without retry', (
    tester,
  ) async {
    await _pump(
      tester,
      const WeeklyEvaluationsFailure(message: 'Server error'),
    );

    expect(find.text('Server error'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('save failure stays inline and preserves edit values', (
    tester,
  ) async {
    await _pumpForm(
      tester,
      EvaluationDialogContext.edit(
        const EvaluationEditorContext(
          studentId: 'student',
          studentName: 'Student',
          classroomId: 'classroom',
          classroomName: 'Class A',
          week: 2,
          subject: _evaluatedSubject,
        ),
      ),
      repo: _SaveFailureRepo(),
    );

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Server rejected evaluation'), findsOneWidget);
    expect(find.byType(WeeklyEvaluationForm), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(_dropdownByLabel(tester, 'Behavior').value, 'very_good');
  });

  testWidgets('classroom and week filters call the selected flow values', (
    tester,
  ) async {
    final repo = _FlowRepo();
    final cubit = WeeklyEvaluationsCubit(repo, _NoopAssignmentsRepo());
    await cubit.initialize('supervisor');
    const classrooms = [
      PlanClassroomOption(id: 'classroom-1', name: 'Class A'),
      PlanClassroomOption(id: 'classroom-2', name: 'Class B'),
    ];
    await cubit.setClassrooms(classrooms);
    await _pump(
      tester,
      BlocProvider.value(
        value: cubit,
        child: WeeklyEvaluationFilters(cubit: cubit, classrooms: classrooms),
      ),
    );

    _dropdownByLabel(tester, 'Classroom').onChanged!('classroom-2');
    await tester.pumpAndSettle();
    expect(cubit.selectedClassroom?.id, 'classroom-2');
    expect(repo.weeklyCalls.last, ('classroom-2', 2));

    _dropdownByLabel(tester, 'Week').onChanged!('1');
    await tester.pumpAndSettle();
    expect(cubit.selectedWeek, 1);
    expect(repo.weeklyCalls.last, ('classroom-2', 1));
  });

  testWidgets('successful save closes the current evaluation dialog', (
    tester,
  ) async {
    final repo = _SaveSuccessRepo();
    final cubit = WeeklyEvaluationsCubit(repo, _NoopAssignmentsRepo());
    final data = EvaluationDialogContext.edit(
      const EvaluationEditorContext(
        studentId: 'student',
        studentName: 'Student',
        classroomId: 'classroom',
        classroomName: 'Class A',
        week: 2,
        subject: _evaluatedSubject,
      ),
    );
    await _pump(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: WeeklyEvaluationDialog(data: data),
            ),
          ),
          child: const Text('Open'),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(WeeklyEvaluationForm), findsOneWidget);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(repo.calls, 1);
    expect(find.byType(WeeklyEvaluationForm), findsNothing);
  });
}

const _evaluatedSubject = EvaluationSubjectModel(
  id: 'subject',
  name: 'Math',
  status: 'evaluated',
  evaluation: EvaluationValueModel(
    attendance: 'present',
    participation: 'good',
    homework: 'good',
    behavior: 'very_good',
    bonus: 4,
  ),
);
Future<void> _pumpForm(
  WidgetTester tester,
  EvaluationDialogContext data, {
  WeeklyEvaluationsRepo? repo,
}) {
  final cubit = WeeklyEvaluationsCubit(
    repo ?? _NoopRepo(),
    _NoopAssignmentsRepo(),
  )..availableWeeks = [1, 2, 3];
  return _pump(
    tester,
    BlocProvider.value(
      value: cubit,
      child: WeeklyEvaluationForm(title: 'Evaluation', data: data),
    ),
  );
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

class _NoopRepo implements WeeklyEvaluationsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LookupRepo extends _NoopRepo {
  int subjectCalls = 0;

  @override
  Future<Either<Failure, List<WeeklyEvaluationStudentModel>>>
  getClassroomStudents(String classroomId) async => const Right([
    WeeklyEvaluationStudentModel(id: 'student', fullName: 'Student'),
  ]);

  @override
  Future<Either<Failure, List<EvaluationSubjectModel>>> getStudentSubjects({
    required String classroomId,
    required String studentId,
  }) async {
    subjectCalls++;
    return const Right([EvaluationSubjectModel(id: 'subject', name: 'Math')]);
  }
}

class _SaveFailureRepo extends _NoopRepo {
  @override
  Future<Either<Failure, Unit>> upsert(
    UpsertEvaluationRequestModel request,
  ) async => Left(Failure(message: 'Server rejected evaluation'));
}

class _SaveSuccessRepo extends _NoopRepo {
  int calls = 0;

  @override
  Future<Either<Failure, Unit>> upsert(
    UpsertEvaluationRequestModel request,
  ) async {
    calls++;
    return const Right(unit);
  }
}

class _FlowRepo extends _NoopRepo {
  final weeklyCalls = <(String, int)>[];

  @override
  Future<Either<Failure, ElapsedEvaluationWeeksModel>> getElapsedWeeks(
    String classroomId,
  ) async => const Right(
    ElapsedEvaluationWeeksModel(
      success: true,
      data: ElapsedEvaluationWeeksData(weeksCount: 2, currentWeek: 2),
    ),
  );

  @override
  Future<Either<Failure, WeeklyEvaluationsResponseModel>> getClassroomWeekly({
    required String classroomId,
    required int week,
  }) async {
    weeklyCalls.add((classroomId, week));
    return Right(
      WeeklyEvaluationsResponseModel(
        success: true,
        data: WeeklyEvaluationsDataModel(
          classroomId: classroomId,
          week: week,
          students: const [WeeklyEvaluationStudentModel(id: 'student')],
        ),
      ),
    );
  }
}

class _NoopAssignmentsRepo implements AssignmentsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

CustomDropdown _dropdownWithItem(WidgetTester tester, String item) => tester
    .widgetList<CustomDropdown>(
      find.byType(CustomDropdown, skipOffstage: false),
    )
    .firstWhere((dropdown) => dropdown.items?.contains(item) ?? false);

CustomDropdown _dropdownByLabel(WidgetTester tester, String label) => tester
    .widgetList<CustomDropdown>(find.byType(CustomDropdown))
    .firstWhere((dropdown) => dropdown.label == label);
