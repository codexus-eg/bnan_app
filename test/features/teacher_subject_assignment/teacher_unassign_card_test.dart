import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignments_cubit/teacher_subject_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/delete_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_assignment_card.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_assignment_details_row.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_subject_assignment_card_item.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('trash opens dialog and success refreshes once', (tester) async {
    final repo = _CardRepo();
    await tester.pumpWidget(_CardApp(repo: repo));
    final row = find.byType(TeacherAssignmentDetailsRow);
    await tester.tap(find.descendant(of: row, matching: find.byType(InkWell)));
    await tester.pumpAndSettle();
    expect(find.byType(DeleteAssignmentDialog), findsOneWidget);

    await tester.tap(find.text('Yes'));
    await tester.pump();
    expect(
      find.text('Grade one - Classroom one - Subject one'),
      findsOneWidget,
    );
    expect(repo.getCalls, 0);
    repo.pending.complete(
      const Right(UnassignTeacherResponseModel(success: true)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DeleteAssignmentDialog), findsNothing);
    expect(repo.getCalls, 1);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}

class _CardApp extends StatelessWidget {
  const _CardApp({required this.repo});
  final _CardRepo repo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => TeacherSubjectAssignmentsCubit(repo)),
          BlocProvider(
            create: (_) => TeacherSubjectAssignmentActionsCubit(repo),
          ),
        ],
        child: const Scaffold(body: TeacherAssignmentCard(item: _item)),
      ),
    );
  }
}

const _item = TeacherSubjectAssignmentCardItem(
  teacherId: 'teacher-1',
  teacherName: 'Teacher one',
  rows: [
    AssignmentRowItem(
      subjectName: 'Subject one',
      gradeName: 'Grade one',
      curriculumName: 'Curriculum one',
      classroomId: 'classroom-1',
      classroomName: 'Classroom one',
      assignmentId: 'assignment-1',
    ),
  ],
);

class _CardRepo implements TeacherSubjectAssignmentRepo {
  final pending = Completer<Either<Failure, UnassignTeacherResponseModel>>();
  int getCalls = 0;

  @override
  Future<Either<Failure, TeachingAssignmentsResponseModel>>
  getTeacherTeachingAssignments() async {
    getCalls++;
    return const Right(
      TeachingAssignmentsResponseModel(success: true, length: 0, data: []),
    );
  }

  @override
  Future<Either<Failure, UnassignTeacherResponseModel>>
  unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) => pending.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
