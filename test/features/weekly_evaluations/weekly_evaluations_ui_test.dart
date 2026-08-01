import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/weekly_evaluation_subject_ui_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/dialogs/weekly_evaluation_dialog.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_card.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_body.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _evaluation = WeeklyEvaluationModel(
  studentName: 'Student One',
  classLabel: 'Class A',
  weekStart: '03/15/2026',
  previewImage: '',
  attendance: 'Excellent',
  participation: 'Very Good',
  assignments: 'Good',
  behavior: 'Excellent',
  notes: 'Progress note',
);

void main() {
  test('access policy matches the four supported roles', () {
    final supervisor = WeeklyEvaluationsAccessPolicy.fromRole('supervisor');
    final teacher = WeeklyEvaluationsAccessPolicy.fromRole('teacher');
    final parent = WeeklyEvaluationsAccessPolicy.fromRole('parent');
    final student = WeeklyEvaluationsAccessPolicy.fromRole('student');

    expect(supervisor.canAdd, isTrue);
    expect(teacher.canAdd, isTrue);
    expect(parent.isReadOnly, isTrue);
    expect(parent.canFilterByClassroom, isFalse);
    expect(student.isStudent, isTrue);
    expect(student.canEdit, isFalse);
  });

  testWidgets('supervisor sees add filter edit and subject field', (
    tester,
  ) async {
    await _pumpBody(tester, 'supervisor');

    expect(find.text('Add New Evaluation'), findsOneWidget);
    expect(find.text('Send All'), findsNothing);
    expect(find.byType(CustomDropdown), findsOneWidget);
    expect(find.byTooltip('Edit Evaluation'), findsOneWidget);
    await tester.tap(find.text('Add New Evaluation'));
    await tester.pumpAndSettle();

    expect(_subjectDropdown, findsOneWidget);
  });

  testWidgets('teacher sees add and subject field but no send all', (
    tester,
  ) async {
    await _pumpBody(tester, 'teacher');

    expect(find.text('Add New Evaluation'), findsOneWidget);
    expect(find.text('Send All'), findsNothing);
    expect(find.byType(CustomDropdown), findsOneWidget);
    await tester.tap(find.text('Add New Evaluation'));
    await tester.pumpAndSettle();

    expect(find.byType(WeeklyEvaluationDialog), findsOneWidget);
    expect(_subjectDropdown, findsOneWidget);
  });

  testWidgets('parent sees multiple read-only student cards', (tester) async {
    await _pumpBody(
      tester,
      'parent',
      evaluations: const [
        _evaluation,
        WeeklyEvaluationModel(
          studentName: 'Student Two',
          classLabel: 'Class B',
          weekStart: '03/15/2026',
          previewImage: '',
          attendance: 'Good',
          participation: 'Good',
          assignments: 'Good',
          behavior: 'Good',
          notes: '',
        ),
      ],
    );

    expect(find.byType(WeeklyEvaluationCard), findsNWidgets(2));
    expect(find.textContaining('Student One'), findsOneWidget);
    expect(find.textContaining('Student Two'), findsOneWidget);
    expect(find.byType(CustomDropdown), findsNothing);
    expect(find.byTooltip('Edit Evaluation'), findsNothing);
  });

  testWidgets('student sees one shared read-only table', (tester) async {
    await _pumpBody(tester, 'student');

    expect(find.byType(WeeklyEvaluationTable), findsOneWidget);
    expect(find.byType(CustomDropdown), findsNothing);
    expect(find.text('Add New Evaluation'), findsNothing);
    expect(find.byTooltip('Edit Evaluation'), findsNothing);
  });

  testWidgets('edit opens one prefilled dialog', (tester) async {
    await _pumpBody(tester, 'supervisor');
    await tester.tap(find.byTooltip('Edit Evaluation'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Evaluation'), findsWidgets);
    expect(find.text('Student One'), findsWidgets);
    expect(find.text('Progress note'), findsOneWidget);
  });

  testWidgets('shared table has four headers and no narrow overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pump(
      tester,
      const WeeklyEvaluationTable(
        subjects: [
          WeeklyEvaluationSubjectUiModel(
            subjectName: 'Mathematics',
            attendance: 'Excellent',
            participation: 'Very Good',
            homework: 'Good',
            notes: 'Progress note',
          ),
        ],
      ),
    );

    expect(find.text('Subject'), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.text('Participation'), findsOneWidget);
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Progress note'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading failure and empty keep presentation states', (
    tester,
  ) async {
    await _pumpBody(tester, 'teacher', isLoading: true);
    expect(find.byType(AppSkeletonizer), findsWidgets);

    await _pumpBody(tester, 'teacher', errorMessage: 'Failed');
    expect(find.byType(WeeklyEvaluationsFailure), findsOneWidget);
    expect(find.text('Add New Evaluation'), findsOneWidget);

    await _pumpBody(tester, 'teacher', evaluations: const []);
    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(find.text('Add New Evaluation'), findsOneWidget);
  });
}

Future<void> _pumpBody(
  WidgetTester tester,
  String role, {
  List<WeeklyEvaluationModel> evaluations = const [_evaluation],
  bool isLoading = false,
  String? errorMessage,
}) {
  return _pump(
    tester,
    WeeklyEvaluationsBody(
      policy: WeeklyEvaluationsAccessPolicy.fromRole(role),
      evaluations: evaluations,
      isLoading: isLoading,
      errorMessage: errorMessage,
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

final _subjectDropdown = find.byWidgetPredicate(
  (widget) => widget is CustomDropdown && widget.label == 'Subject',
);
