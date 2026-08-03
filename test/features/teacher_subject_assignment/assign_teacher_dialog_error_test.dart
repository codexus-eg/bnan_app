import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_response_model.dart';
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
  testWidgets('failure shows backend message and retry clears it', (
    tester,
  ) async {
    final lookups = AcademicLookupsCubit(repo: _LookupsRepo());
    final repo = _TeacherRepo();
    final actions = TeacherSubjectAssignmentActionsCubit(repo);
    addTearDown(lookups.close);
    addTearDown(actions.close);
    await _selectReadyLookups(lookups);
    await tester.pumpWidget(_TestApp(lookups: lookups, actions: actions));
    lookups.selectSubject(null);
    lookups.selectSubject(_subject);
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '300');
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text(_backendMessage), findsOneWidget);
    expect(find.text(_internalId), findsNothing);
    expect(find.byType(AssignSubjectDialog), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('300'), findsOneWidget);
    final errorText = tester.widget<Text>(find.text(_backendMessage));
    expect(errorText.softWrap, isTrue);
    expect(errorText.maxLines, isNull);

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text(_backendMessage), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repo.retry.complete(
      const Right(AssignTeacherResponseModel(success: true, message: 'ok')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AssignSubjectDialog), findsNothing);
  });
}

Future<void> _selectReadyLookups(AcademicLookupsCubit cubit) async {
  await cubit.selectCurriculum(_curriculum);
  await cubit.selectGrade(_grade);
  await cubit.selectClassroom(_classroom);
  cubit.selectSubject(_subject);
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.lookups, required this.actions});
  final AcademicLookupsCubit lookups;
  final TeacherSubjectAssignmentActionsCubit actions;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: lookups),
          BlocProvider.value(value: actions),
        ],
        child: const Scaffold(
          body: AssignSubjectDialog(
            teacherId: 'teacher-1',
            teacherName: 'Teacher one',
          ),
        ),
      ),
    );
  }
}

class _TeacherRepo implements TeacherSubjectAssignmentRepo {
  int calls = 0;
  final retry = Completer<Either<Failure, AssignTeacherResponseModel>>();

  @override
  Future<Either<Failure, AssignTeacherResponseModel>> assignTeacher({
    required String teacherId,
    required AssignTeacherRequestModel request,
  }) async {
    calls++;
    if (calls == 1) return Left(Failure(message: _backendMessage));
    return retry.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LookupsRepo implements AcademicLookupsRepo {
  @override
  Future<Either<Failure, List<AcademicCurriculumModel>>>
  getCurriculums() async => const Right([_curriculum]);
  @override
  Future<Either<Failure, List<AcademicGradeModel>>> getGrades({
    String? curriculumId,
  }) async => const Right([_grade]);
  @override
  Future<Either<Failure, List<AcademicClassroomModel>>> getClassroomsByGrade({
    required String curriculumId,
    required String gradeId,
  }) async => const Right([_classroom]);
  @override
  Future<Either<Failure, List<AcademicSubjectModel>>> getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) async => const Right([_subject]);
}

const _curriculum = AcademicCurriculumModel(id: 'c', name: 'Curriculum');
const _grade = AcademicGradeModel(id: 'g', name: 'Grade');
const _classroom = AcademicClassroomModel(id: 'r', name: 'Classroom');
const _subject = AcademicSubjectModel(id: 's', name: 'Subject');
const _internalId = '6a39bb71441c9c5929b4ed9c';
const _backendMessage =
    'يوجد معلم معيّن بالفعل لهذا الفصل الخليجي. يجب إلغاء تعيين المعلم الحالي '
    'أولاً قبل تعيين معلم جديد.';
