import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_assignment_details_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('details wrap in grade classroom subject order', (tester) async {
    var deletePressed = false;
    await tester.binding.setSurfaceSize(const Size(260, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TeacherAssignmentDetailsRow(
            row: _longRow,
            onTap: () => deletePressed = true,
          ),
        ),
      ),
    );

    final details = find.text(_expectedDetails);
    expect(details, findsOneWidget);
    final text = tester.widget<Text>(details);
    expect(text.softWrap, isTrue);
    expect(text.maxLines, isNull);
    expect(text.overflow, isNull);
    expect(
      tester.getSize(find.byType(TeacherAssignmentDetailsRow)).height,
      greaterThan(40),
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(InkWell));
    expect(deletePressed, isTrue);
  });

  testWidgets('empty details use dashes without hiding other values', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TeacherAssignmentDetailsRow(row: _missingRow, onTap: _noop),
        ),
      ),
    );
    expect(find.text('- - Classroom one - -'), findsOneWidget);
  });
}

const _expectedDetails =
    'A very long grade name - A very long classroom name that wraps naturally - '
    'A very long subject name that must never use ellipsis';

const _longRow = AssignmentRowItem(
  gradeName: 'A very long grade name',
  classroomName: 'A very long classroom name that wraps naturally',
  subjectName: 'A very long subject name that must never use ellipsis',
  curriculumName: 'Curriculum',
  classroomId: 'classroom-1',
  assignmentId: 'assignment-1',
);

const _missingRow = AssignmentRowItem(
  gradeName: '',
  classroomName: 'Classroom one',
  subjectName: ' ',
  curriculumName: 'Curriculum',
  classroomId: 'classroom-1',
  assignmentId: 'assignment-1',
);

void _noop() {}
