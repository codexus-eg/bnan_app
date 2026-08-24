import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/assign_supervisor_dialog.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/widgets/dialogs/cancel_supervisor_assignment_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('assign failure stays inline and preserves classroom', (
    tester,
  ) async {
    final pending =
        Completer<Either<Failure, SupervisorAssignmentsResponseModel>>();
    final repo = _SupervisorRepo(
      assignResults: [
        Future.value(Left(Failure(message: 'assign failed'))),
        pending.future,
      ],
    );
    await _pumpAssignDialog(tester, repo);
    await _selectClassroom(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('assign failed'), findsOneWidget);
    expect(find.byType(AssignSupervisorDialog), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('Class one'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('assign failed'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Class one'), findsOneWidget);
    pending.complete(Left(Failure(message: 'retry failed')));
    await tester.pumpAndSettle();
  });

  testWidgets('unassign failure stays inline without snackbar', (tester) async {
    final repo = _SupervisorRepo(
      unassignResult: Left(Failure(message: 'remove failed')),
    );
    await _pumpCancelDialog(tester, repo);

    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    expect(find.text('remove failed'), findsOneWidget);
    expect(find.byType(CancelSupervisorAssignmentDialog), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('assign success closes dialog and refreshes once', (
    tester,
  ) async {
    final repo = _SupervisorRepo();
    await _pumpAssignDialog(tester, repo);
    await _selectClassroom(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AssignSupervisorDialog), findsNothing);
    expect(repo.listCalls, 1);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('empty grades show inline feedback and disable save', (
    tester,
  ) async {
    await _pumpAssignDialog(
      tester,
      _SupervisorRepo(),
      academicRepo: _AcademicRepo(grades: const []),
    );

    expect(
      find.text('No grades are available for this curriculum'),
      findsOneWidget,
    );
    expect(_saveButton(tester).onPressed, isNull);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('empty classrooms show inline feedback and disable save', (
    tester,
  ) async {
    await _pumpAssignDialog(
      tester,
      _SupervisorRepo(),
      academicRepo: _AcademicRepo(classrooms: const []),
    );
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Grade one').last);
    await tester.pumpAndSettle();

    expect(
      find.text('No classrooms are available for this grade'),
      findsOneWidget,
    );
    expect(_saveButton(tester).onPressed, isNull);
    expect(find.byType(SnackBar), findsNothing);
  });
}

Future<void> _pumpAssignDialog(
  WidgetTester tester,
  _SupervisorRepo repo, {
  _AcademicRepo? academicRepo,
}) async {
  final listCubit = GetSupervisorsCubit(repo);
  final actionsCubit = SupervisorAssignmentActionsCubit(repo);
  addTearDown(listCubit.close);
  addTearDown(actionsCubit.close);
  await _pumpDialogHost(
    tester,
    onOpen: (context) => showDialog<void>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) =>
            AcademicLookupsCubit(repo: academicRepo ?? _AcademicRepo()),
        child: AssignSupervisorDialog(
          supervisorId: 'supervisor-1',
          getSupervisorsCubit: listCubit,
          actionsCubit: actionsCubit,
          supervisorName: 'Supervisor one',
          curriculumId: 'curriculum-1',
          curriculumName: 'Curriculum one',
          assignedClassroomIds: const {},
        ),
      ),
    ),
  );
}

ElevatedButton _saveButton(WidgetTester tester) =>
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Save'));

Future<void> _pumpCancelDialog(
  WidgetTester tester,
  _SupervisorRepo repo,
) async {
  final listCubit = GetSupervisorsCubit(repo);
  final actionsCubit = SupervisorAssignmentActionsCubit(repo);
  addTearDown(listCubit.close);
  addTearDown(actionsCubit.close);
  await _pumpDialogHost(
    tester,
    onOpen: (context) => showDialog<void>(
      context: context,
      builder: (_) => CancelSupervisorAssignmentDialog(
        supervisorId: 'supervisor-1',
        classroomId: 'classroom-1',
        classroomName: 'Class one',
        getSupervisorsCubit: listCubit,
        actionsCubit: actionsCubit,
      ),
    ),
  );
}

Future<void> _pumpDialogHost(
  WidgetTester tester, {
  required Future<void> Function(BuildContext) onOpen,
}) async {
  await tester.binding.setSurfaceSize(const Size(500, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => onOpen(context),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

Future<void> _selectClassroom(WidgetTester tester) async {
  await tester.tap(find.byType(DropdownButton<String>).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Grade one').last);
  await tester.pumpAndSettle();
  await tester.tap(find.byType(DropdownButton<String>).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Class one').last);
  await tester.pumpAndSettle();
}

class _AcademicRepo implements AcademicLookupsRepo {
  _AcademicRepo({
    this.grades = const [AcademicGradeModel(id: 'grade-1', name: 'Grade one')],
    this.classrooms = const [
      AcademicClassroomModel(id: 'classroom-1', name: 'Class one'),
    ],
  });

  final List<AcademicGradeModel> grades;
  final List<AcademicClassroomModel> classrooms;

  @override
  Future<Either<Failure, Unit>> addClassroomSubject({
    required String classroomId,
    required String subjectId,
  }) async => const Right(unit);

  @override
  Future<Either<Failure, List<AcademicGradeModel>>> getGrades({
    String? curriculumId,
  }) async => Right(grades);

  @override
  Future<Either<Failure, List<AcademicClassroomModel>>> getClassroomsByGrade({
    required String curriculumId,
    required String gradeId,
  }) async => Right(classrooms);

  @override
  Future<Either<Failure, List<AcademicCurriculumModel>>>
  getCurriculums() async => const Right([]);

  @override
  Future<Either<Failure, List<AcademicSubjectModel>>> getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) async => const Right([]);
}

class _SupervisorRepo implements SupervisorAssignmentRepo {
  _SupervisorRepo({
    List<Future<Either<Failure, SupervisorAssignmentsResponseModel>>>?
    assignResults,
    Either<Failure, UnassignSupervisorResponseModel>? unassignResult,
  }) : assignResults =
           assignResults ??
           [Future.value(const Right(SupervisorAssignmentsResponseModel()))],
       unassignResult =
           unassignResult ?? const Right(UnassignSupervisorResponseModel());

  final List<Future<Either<Failure, SupervisorAssignmentsResponseModel>>>
  assignResults;
  final Either<Failure, UnassignSupervisorResponseModel> unassignResult;
  int listCalls = 0;
  int assignCalls = 0;

  @override
  Future<Either<Failure, GetSupervisorsResponseModel>> getSupervisors() async {
    listCalls++;
    return const Right(GetSupervisorsResponseModel());
  }

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  assignSupervisorToClassrooms({
    required String supervisorId,
    required AssignSupervisorRequestModel request,
  }) {
    return assignResults[assignCalls++];
  }

  @override
  Future<Either<Failure, UnassignSupervisorResponseModel>>
  unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  }) async => unassignResult;

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  getSupervisorAssignments({required String supervisorId}) async =>
      const Right(SupervisorAssignmentsResponseModel());
}
