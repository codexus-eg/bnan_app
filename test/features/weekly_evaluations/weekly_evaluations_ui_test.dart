import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_value_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/repo/weekly_evaluations_repo.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_dialog_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_editor_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_subject_actions.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_card.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_form.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_header_actions.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  test('student and parent are read only while teacher can manage', () {
    expect(WeeklyEvaluationsAccessPolicy.fromRole('teacher').canEdit, isTrue);
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

  testWidgets('add form shows week and never renders week-start picker', (
    tester,
  ) async {
    await _pumpForm(
      tester,
      const EvaluationDialogContext.add(
        students: [_student],
        classroomId: 'classroom',
        classroomName: 'Class A',
        week: 2,
      ),
    );

    expect(find.text('Week Start'), findsNothing);
    expect(find.text('Week 2'), findsOneWidget);
    expect(find.widgetWithText(CustomDropdown, 'Student'), findsOneWidget);
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
  ),
);
const _student = WeeklyEvaluationStudentModel(
  id: 'student',
  fullName: 'Student',
  subjects: [EvaluationSubjectModel(id: 'new', name: 'Physics')],
);

Future<void> _pumpForm(WidgetTester tester, EvaluationDialogContext data) =>
    _pump(
      tester,
      BlocProvider(
        create: (_) => WeeklyEvaluationsCubit(_NoopRepo()),
        child: WeeklyEvaluationForm(title: 'Evaluation', data: data),
      ),
    );

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
