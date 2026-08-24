import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'changing classroom clears subject and rejects a stale response',
    () async {
      final repo = _DelayedSubjectsRepo();
      final cubit = AcademicLookupsCubit(repo: repo);
      addTearDown(cubit.close);
      await cubit.selectCurriculum(_curriculum);
      await cubit.selectGrade(_grade);
      await cubit.selectClassroom(_classroomB);
      cubit.selectSubject(_subjectB);
      expect(cubit.state.selectedSubject?.id, _subjectB.id);

      final classroomAFuture = cubit.selectClassroom(_classroomA);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.selectedClassroom?.id, _classroomA.id);
      expect(cubit.state.selectedSubject, isNull);
      expect(cubit.state.subjects, isEmpty);
      expect(cubit.state.isLoadingSubjects, isTrue);

      await cubit.selectClassroom(_classroomB);
      expect(cubit.state.selectedClassroom?.id, _classroomB.id);
      expect(cubit.state.selectedSubject, isNull);
      expect(cubit.state.subjects.single.id, _subjectB.id);
      repo.classroomA.complete(const Right([_subjectA]));
      await classroomAFuture;

      expect(cubit.state.selectedClassroom?.id, _classroomB.id);
      expect(cubit.state.subjects.single.id, _subjectB.id);
      expect(cubit.state.isLoadingSubjects, isFalse);
    },
  );
}

const _curriculum = AcademicCurriculumModel(
  id: 'curriculum-1',
  name: 'Curriculum one',
);
const _grade = AcademicGradeModel(id: 'grade-1', name: 'Grade one');
const _classroomA = AcademicClassroomModel(id: 'class-a', name: 'Class A');
const _classroomB = AcademicClassroomModel(id: 'class-b', name: 'Class B');
const _subjectA = AcademicSubjectModel(id: 'subject-a', name: 'Subject A');
const _subjectB = AcademicSubjectModel(id: 'subject-b', name: 'Subject B');

class _DelayedSubjectsRepo implements AcademicLookupsRepo {
  final classroomA = Completer<Either<Failure, List<AcademicSubjectModel>>>();

  @override
  Future<Either<Failure, Unit>> addClassroomSubject({
    required String classroomId,
    required String subjectId,
  }) async => const Right(unit);

  @override
  Future<Either<Failure, List<AcademicGradeModel>>> getGrades({
    String? curriculumId,
  }) async => const Right([_grade]);

  @override
  Future<Either<Failure, List<AcademicClassroomModel>>> getClassroomsByGrade({
    required String curriculumId,
    required String gradeId,
  }) async => const Right([_classroomA, _classroomB]);

  @override
  Future<Either<Failure, List<AcademicSubjectModel>>> getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) {
    if (classroomId == _classroomA.id) return classroomA.future;
    return Future.value(const Right([_subjectB]));
  }

  @override
  Future<Either<Failure, List<AcademicCurriculumModel>>>
  getCurriculums() async => const Right([_curriculum]);
}
