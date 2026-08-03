import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/assign_subject_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('teacher dialog explains empty grades and disables save', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_TestApp());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Curriculum one').last);
    await tester.pumpAndSettle();

    expect(
      find.text('No grades are available for this curriculum'),
      findsOneWidget,
    );
    final save = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Save'),
    );
    expect(save.onPressed, isNull);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('teacher dialog explains empty classrooms', (tester) async {
    await _openDialog(tester, _EmptyAt.classrooms);
    await _select(tester, 0, 'Curriculum one');
    await _select(tester, 1, 'Grade one');
    expect(
      find.text('No classrooms are available for this grade'),
      findsOneWidget,
    );
    _expectSaveDisabled(tester);
  });

  testWidgets('teacher dialog explains empty subjects', (tester) async {
    await _openDialog(tester, _EmptyAt.subjects);
    await _select(tester, 0, 'Curriculum one');
    await _select(tester, 1, 'Grade one');
    await _select(tester, 2, 'Classroom one');
    expect(
      find.text('No subjects are available for this classroom'),
      findsOneWidget,
    );
    _expectSaveDisabled(tester);
  });

  testWidgets('subjects failure shows the API error instead of empty text', (
    tester,
  ) async {
    await _openDialog(tester, _EmptyAt.subjectFailure);
    await _select(tester, 0, 'Curriculum one');
    await _select(tester, 1, 'Grade one');
    await _select(tester, 2, 'Classroom one');
    expect(find.text('subjects failed'), findsOneWidget);
    expect(
      find.text('No subjects are available for this classroom'),
      findsNothing,
    );
    _expectSaveDisabled(tester);
  });
}

Future<void> _openDialog(WidgetTester tester, _EmptyAt emptyAt) async {
  await tester.binding.setSurfaceSize(const Size(500, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(_TestApp(emptyAt: emptyAt));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

Future<void> _select(WidgetTester tester, int index, String label) async {
  await tester.tap(find.byType(DropdownButton<String>).at(index));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void _expectSaveDisabled(WidgetTester tester) {
  final save = tester.widget<ElevatedButton>(
    find.widgetWithText(ElevatedButton, 'Save'),
  );
  expect(save.onPressed, isNull);
}

enum _EmptyAt { grades, classrooms, subjects, subjectFailure }

class _TestApp extends StatelessWidget {
  const _TestApp({this.emptyAt = _EmptyAt.grades});

  final _EmptyAt emptyAt;

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
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        AcademicLookupsCubit(repo: _AcademicRepo(emptyAt)),
                  ),
                  BlocProvider(
                    create: (_) =>
                        TeacherSubjectAssignmentActionsCubit(_TeacherRepo()),
                  ),
                ],
                child: const AssignSubjectDialog(
                  teacherId: 'teacher-1',
                  teacherName: 'Teacher one',
                ),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }
}

class _AcademicRepo implements AcademicLookupsRepo {
  const _AcademicRepo(this.emptyAt);

  final _EmptyAt emptyAt;

  @override
  Future<Either<Failure, List<AcademicCurriculumModel>>>
  getCurriculums() async => const Right([
    AcademicCurriculumModel(id: 'curriculum-1', name: 'Curriculum one'),
  ]);

  @override
  Future<Either<Failure, List<AcademicGradeModel>>> getGrades({
    String? curriculumId,
  }) async => emptyAt == _EmptyAt.grades
      ? const Right([])
      : const Right([AcademicGradeModel(id: 'grade-1', name: 'Grade one')]);

  @override
  Future<Either<Failure, List<AcademicClassroomModel>>> getClassroomsByGrade({
    required String curriculumId,
    required String gradeId,
  }) async => emptyAt == _EmptyAt.classrooms
      ? const Right([])
      : const Right([
          AcademicClassroomModel(id: 'classroom-1', name: 'Classroom one'),
        ]);

  @override
  Future<Either<Failure, List<AcademicSubjectModel>>> getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) async => emptyAt == _EmptyAt.subjectFailure
      ? Left(Failure(message: 'subjects failed'))
      : const Right([]);
}

class _TeacherRepo implements TeacherSubjectAssignmentRepo {
  @override
  Future<Either<Failure, TeachingAssignmentsResponseModel>>
  getTeacherTeachingAssignments() async =>
      Right(TeachingAssignmentsResponseModel.fromJson(const {}));

  @override
  Future<Either<Failure, AssignCurriculumsResponseModel>>
  assignCurriculumsToTeacher({
    required String teacherId,
    required List<String> curriculumIds,
  }) async => Right(AssignCurriculumsResponseModel.fromJson(const {}));

  @override
  Future<Either<Failure, AssignTeacherResponseModel>> assignTeacher({
    required String teacherId,
    required AssignTeacherRequestModel request,
  }) async =>
      const Right(AssignTeacherResponseModel(success: true, message: ''));

  @override
  Future<Either<Failure, UnassignTeacherResponseModel>>
  unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) async => const Right(UnassignTeacherResponseModel());
}
