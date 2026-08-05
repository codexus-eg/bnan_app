import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses wrapped Gulf schedule response and nested values', () {
    final result = GulfSchedulesResponse.fromJson(
      _response(
        schedule: {
          '_id': 'schedule-1',
          'classroomSubject': {'_id': 'link-1'},
          'entries': [
            {'day': 'Sunday', 'startTime': '18:00'},
          ],
          'isActive': true,
        },
      ),
    );
    final classroom = result.data.classrooms.single;
    expect(classroom.id, 'class-1');
    expect(classroom.subject?.name, 'Math');
    expect(classroom.classroomSubjectId, 'link-1');
    expect(classroom.entries.single.day, 'sunday');
  });

  test('accepts null schedule and explicit top-level classroomSubject', () {
    final classroom = GulfSchedulesResponse.fromJson(
      _response(schedule: null, classroomSubject: 'link-top'),
    ).data.classrooms.single;
    expect(classroom.schedule, isNull);
    expect(classroom.entries, isEmpty);
    expect(classroom.classroomSubjectId, 'link-top');
  });

  test('defaults missing and malformed nested fields safely', () {
    final result = GulfSchedulesResponse.fromJson({
      'success': true,
      'data': {
        'classrooms': [
          {
            '_id': 'class-1',
            'schedule': {'entries': null},
          },
        ],
      },
    });
    expect(result.data.classrooms.single.name, isEmpty);
    expect(result.data.classrooms.single.entries, isEmpty);
  });

  test('parses every classroom from the wrapped student contract', () {
    final classrooms = List.generate(
      70,
      (index) => {
        'id': 'class-$index',
        'hasSubjectConflict': index == 0,
        'schedule': {
          'id': 'schedule-$index',
          'classroomSubject': 'link-$index',
          'entries': [
            {'day': 'sunday', 'startTime': '18:00'},
          ],
          'createdAt': '2026-08-01T10:00:00.000Z',
          'updatedAt': '2026-08-05T10:00:00.000Z',
        },
      },
    );
    final result = GulfSchedulesResponse.fromJson({
      'success': true,
      'data': {
        'students': [
          {'classrooms': classrooms},
        ],
      },
    });

    expect(result.data.classrooms, hasLength(70));
    expect(result.data.classrooms.first.hasSubjectConflict, isTrue);
    expect(result.data.classrooms.last.schedule?.createdAt, isNotNull);
    expect(result.data.classrooms.last.schedule?.updatedAt, isNotNull);
  });

  test('request sends classroomSubject and day/startTime only', () {
    const request = GulfScheduleRequest(
      classroomSubject: 'link-1',
      schedule: [GulfScheduleEntry(day: 'tuesday', startTime: '09:30')],
    );
    expect(request.toJson(), {
      'classroomSubject': 'link-1',
      'schedule': [
        {'day': 'tuesday', 'startTime': '09:30'},
      ],
    });
  });
}

Map<String, dynamic> _response({
  required Object? schedule,
  String? classroomSubject,
}) => {
  'success': true,
  'data': {
    'classrooms': [
      {
        '_id': 'class-1',
        'name': 'Class A',
        'subject': {'id': 'subject-1', 'name': 'Math'},
        if (classroomSubject != null) 'classroomSubject': classroomSubject,
        'schedule': schedule,
      },
    ],
  },
};
