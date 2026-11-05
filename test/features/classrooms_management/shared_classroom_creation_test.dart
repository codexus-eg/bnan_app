import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_creator.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_form_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await S.load(const Locale('ar'));
  });

  group('Shared Classroom Subject Union & De-duplication', () {
    test('filters out duplicate subject names case and trim insensitively', () {
      const state = SharedClassroomFormState(
        subjectsA: [
          AcademicSubjectModel(id: 'sub_1', name: 'Mathematics'),
          AcademicSubjectModel(id: 'sub_2', name: 'Arabic Language'),
          AcademicSubjectModel(id: 'sub_3', name: 'Science'),
        ],
        subjectsB: [
          AcademicSubjectModel(id: 'sub_4', name: '  mathematics  '),
          AcademicSubjectModel(id: 'sub_5', name: 'ARABIC LANGUAGE'),
          AcademicSubjectModel(id: 'sub_6', name: 'English'),
        ],
      );

      final union = state.unionSubjects;
      expect(union.length, 4);
      final names = union.map((s) => s.name.trim().toLowerCase()).toList();
      expect(names, containsAll(['mathematics', 'arabic language', 'science', 'english']));
    });
  });

  group('buildSharedClassroomRequest Validation', () {
    const grades = [
      AcademicGradeModel(id: 'g_1', name: 'Grade 1'),
      AcademicGradeModel(id: 'g_2', name: 'Grade 2'),
    ];

    test('fails when targets are missing', () {
      String? error;
      final result = buildSharedClassroomRequest(
        name: 'Shared Room',
        state: const SharedClassroomFormState(curriculumId: 'eg_curr', grades: grades),
        supervisorId: 'sup_1',
        onError: (e) => error = e,
      );

      expect(result, isNull);
      expect(error, S.current.sharedClassroomTargetsRequired);
    });

    test('fails when two identical grades are selected', () {
      String? error;
      final result = buildSharedClassroomRequest(
        name: 'Shared Room',
        state: const SharedClassroomFormState(
          curriculumId: 'eg_curr',
          grades: grades,
          grade1Id: 'g_1',
          grade2Id: 'g_1',
        ),
        supervisorId: 'sup_1',
        onError: (e) => error = e,
      );

      expect(result, isNull);
      expect(error, S.current.sharedClassroomRequiresTwoTargets);
    });

    test('fails when supervisor is null', () {
      String? error;
      final result = buildSharedClassroomRequest(
        name: 'Shared Room',
        state: const SharedClassroomFormState(
          curriculumId: 'eg_curr',
          grades: grades,
          grade1Id: 'g_1',
          grade2Id: 'g_2',
        ),
        supervisorId: null,
        onError: (e) => error = e,
      );

      expect(result, isNull);
      expect(error, S.current.fillAllRequiredFields);
    });

    test('succeeds with valid targets and selects primary target', () {
      String? error;
      final result = buildSharedClassroomRequest(
        name: 'Shared Room',
        state: const SharedClassroomFormState(
          curriculumId: 'eg_curr',
          grades: grades,
          grade1Id: 'g_1',
          grade2Id: 'g_2',
          primaryTargetIndex: 1,
          selectedSubjectIds: {'sub_1', 'sub_2'},
        ),
        supervisorId: 'sup_1',
        onError: (e) => error = e,
      );

      expect(error, isNull);
      expect(result, isNotNull);
      expect(result!.classroomKind, 'shared');
      expect(result.gradeId, 'g_2');
      expect(result.curriculumId, 'eg_curr');
      expect(result.sharedAcademicTargets?.length, 2);
      expect(result.subjects, ['sub_1', 'sub_2']);
      expect(result.meetingLink, isNull);
    });
  });
}

