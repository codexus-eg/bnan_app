import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_availability_status.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('final Gulf contract parses classroom metadata and statuses', () {
    final model = _parse({
      'student': {'id': 'student'},
      'mode': 'gulf',
      'classroomsCount': 3,
      'week': 2,
      'weekStart': '2026-08-01T00:00:00.000Z',
      'classrooms': [
        _gulfClassroom('english', status: 'evaluated', evaluated: true),
        _gulfClassroom('math', status: 'not_evaluated'),
        {
          'id': 'unavailable',
          'name': 'Unavailable',
          'evaluationStatus': 'not_available',
          'subject': null,
          'evaluation': null,
        },
      ],
      'subjects': <Object>[],
    });
    final data = model.data;
    final evaluated = data.classrooms.first;

    expect(data.mode, EvaluationMode.gulf);
    expect(data.classroomsCount, 3);
    expect(data.week, 2);
    expect(data.weekStart, '2026-08-01T00:00:00.000Z');
    expect(data.classrooms, hasLength(3));
    expect(evaluated.grade?.id, 'grade-english');
    expect(evaluated.curriculum?.id, 'curriculum-english');
    expect(evaluated.subject?.id, 'subject-english');
    expect(evaluated.evaluationStatus, EvaluationAvailabilityStatus.evaluated);
    expect(evaluated.evaluation?.id, 'evaluation-english');
    expect(evaluated.evaluation?.createdByRole, 'teacher');
    expect(
      data.classrooms[1].evaluationStatus,
      EvaluationAvailabilityStatus.notEvaluated,
    );
    expect(data.classrooms[1].evaluation, isNull);
    expect(
      data.classrooms[2].evaluationStatus,
      EvaluationAvailabilityStatus.notAvailable,
    );
    expect(data.classrooms[2].subject, isNull);
    expect(data.subjects, isEmpty);
  });

  test('unknown Gulf status does not infer from evaluation or crash', () {
    final classroom = _parse({
      'mode': 'gulf',
      'classrooms': [
        _gulfClassroom('unknown', status: 'future_status', evaluated: true),
      ],
    }).data.classrooms.single;
    expect(classroom.evaluationStatus, EvaluationAvailabilityStatus.unknown);
    expect(classroom.evaluation, isNotNull);
  });

  test('missing Gulf status uses documented fallback', () {
    final classrooms = _parse({
      'classrooms': [
        _gulfClassroom('evaluated', evaluated: true),
        _gulfClassroom('pending'),
        {'id': 'missing', 'subject': null, 'evaluation': null},
      ],
    }).data.classrooms;
    expect(
      classrooms[0].evaluationStatus,
      EvaluationAvailabilityStatus.evaluated,
    );
    expect(
      classrooms[1].evaluationStatus,
      EvaluationAvailabilityStatus.notEvaluated,
    );
    expect(
      classrooms[2].evaluationStatus,
      EvaluationAvailabilityStatus.notAvailable,
    );
  });

  test('missing mode is unknown and missing optional collections are safe', () {
    final data = _parse(<String, dynamic>{}).data;
    expect(data.mode, EvaluationMode.unknown);
    expect(data.classroomsCount, 0);
    expect(data.classrooms, isEmpty);
    expect(data.subjects, isEmpty);
    expect(data.week, isNull);
    expect(data.weekStart, isNull);
  });

  test('Egyptian contract keeps not evaluated subjects', () {
    final data = _parse({
      'mode': 'egyptian',
      'classroom': {'id': 'classroom', 'name': 'Grade 1 A'},
      'grade': {'_id': 'grade', 'name': 'Grade 1'},
      'curriculum': {'id': 'curriculum', 'name': 'Egyptian'},
      'subjects': [
        {
          'id': 'math',
          'name': 'Math',
          'status': 'evaluated',
          'evaluation': {'_id': 'evaluation', 'attendance': 'present'},
        },
        {
          'id': 'arabic',
          'name': 'Arabic',
          'status': 'not_evaluated',
          'evaluation': null,
        },
      ],
    }).data;
    expect(data.mode, EvaluationMode.egyptian);
    expect(data.classroom?.id, 'classroom');
    expect(data.grade?.id, 'grade');
    expect(data.curriculum?.id, 'curriculum');
    expect(data.subjects, hasLength(2));
    expect(data.subjects.first.evaluation?.id, 'evaluation');
    expect(data.subjects.last.status, 'not_evaluated');
    expect(data.subjects.last.evaluation, isNull);
  });

  test('read-only bonus prioritizes bonus and falls back to bouns', () {
    final correct = _parse({
      'subjects': [
        {
          'evaluation': {'bonus': 4, 'bouns': 2},
        },
      ],
    }).data.subjects.single.evaluation;
    final legacy = _parse({
      'subjects': [
        {
          'evaluation': {'bonus': null, 'bouns': '3'},
        },
      ],
    }).data.subjects.single.evaluation;
    expect(correct?.bonus, 4);
    expect(legacy?.bonus, 3);
  });

  test('parent child still supports multiple classroom references', () {
    final child = ParentEvaluationChildModel.fromJson({
      '_id': 'child',
      'userId': 'user-child',
      'name': 'Child Name',
      'classrooms': [
        {'id': 'c1', 'name': 'Class 1'},
        {'id': 'c2', 'name': 'Class 2'},
      ],
    });
    expect(child.id, 'child');
    expect(child.userId, 'user-child');
    expect(child.fullName, 'Child Name');
    expect(child.classroom, isNull);
    expect(child.classrooms, hasLength(2));
  });
}

Map<String, dynamic> _gulfClassroom(
  String suffix, {
  String? status,
  bool evaluated = false,
}) => {
  'id': 'classroom-$suffix',
  'name': 'Class $suffix',
  'grade': {'id': 'grade-$suffix', 'name': 'Grade'},
  'curriculum': {'id': 'curriculum-$suffix', 'name': 'Curriculum'},
  'subject': {'id': 'subject-$suffix', 'name': 'Subject'},
  if (status != null) 'evaluationStatus': status,
  'evaluation': evaluated
      ? {
          '_id': 'evaluation-$suffix',
          'attendance': 'present',
          'participation': 'excellent',
          'homework': 'good',
          'behavior': 'very_good',
          'notes': 'Good',
          'createdByRole': 'teacher',
          'updatedByRole': 'teacher',
          'createdAt': 'created',
          'updatedAt': 'updated',
        }
      : null,
};

MeWeeklyEvaluationsResponseModel _parse(Map<String, dynamic> data) =>
    MeWeeklyEvaluationsResponseModel.fromJson({'success': true, 'data': data});
