import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/delete_assignment_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dialog shows classroom and has no save button', (tester) async {
    final repo = _DialogRepo();
    await _pumpDialog(tester, repo);
    expect(find.textContaining('Classroom one'), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.byType(DeleteAssignmentDialog), findsNothing);
    expect(repo.calls, 0);
  });

  testWidgets('yes sends the correct IDs and failure stays inline', (
    tester,
  ) async {
    final repo = _DialogRepo()..failure = Failure(message: 'remove failed');
    await _pumpDialog(tester, repo);
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(repo.teacherId, 'teacher-1');
    expect(repo.classroomId, 'classroom-1');
    expect(find.text('remove failed'), findsOneWidget);
    expect(find.byType(DeleteAssignmentDialog), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('only matching success closes the dialog', (tester) async {
    final repo = _DialogRepo();
    await _pumpDialog(tester, repo);
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(repo.calls, 1);
    expect(find.byType(DeleteAssignmentDialog), findsNothing);
  });

  testWidgets('loading disables yes and prevents a duplicate request', (
    tester,
  ) async {
    final repo = _DialogRepo()
      ..pending = Completer<Either<Failure, UnassignTeacherResponseModel>>();
    await _pumpDialog(tester, repo);
    await tester.tap(find.text('Yes'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final yesButton = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton).first,
    );
    expect(yesButton.onPressed, isNull);
    expect(repo.calls, 1);
    repo.pending!.complete(
      const Right(UnassignTeacherResponseModel(success: true)),
    );
    await tester.pumpAndSettle();
  });
}

Future<void> _pumpDialog(WidgetTester tester, _DialogRepo repo) async {
  await tester.pumpWidget(_DialogApp(repo: repo));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

class _DialogApp extends StatelessWidget {
  const _DialogApp({required this.repo});
  final _DialogRepo repo;

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
      home: BlocProvider(
        create: (_) => TeacherSubjectAssignmentActionsCubit(repo),
        child: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                final cubit = context
                    .read<TeacherSubjectAssignmentActionsCubit>();
                showDialog<bool>(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: const DeleteAssignmentDialog(
                      teacherId: 'teacher-1',
                      row: _row,
                    ),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
  }
}

const _row = AssignmentRowItem(
  subjectName: 'Subject one',
  gradeName: 'Grade one',
  curriculumName: 'Curriculum one',
  classroomId: 'classroom-1',
  classroomName: 'Classroom one',
  assignmentId: 'assignment-1',
);

class _DialogRepo implements TeacherSubjectAssignmentRepo {
  int calls = 0;
  Failure? failure;
  String? teacherId;
  String? classroomId;
  Completer<Either<Failure, UnassignTeacherResponseModel>>? pending;

  @override
  Future<Either<Failure, UnassignTeacherResponseModel>>
  unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) async {
    calls++;
    this.teacherId = teacherId;
    this.classroomId = classroomId;
    if (pending != null) return pending!.future;
    if (failure != null) return Left(failure!);
    return const Right(UnassignTeacherResponseModel(success: true));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
