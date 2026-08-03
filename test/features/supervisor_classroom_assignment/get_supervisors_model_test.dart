import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses pagination, supervisor and embedded assignments', () {
    final response = GetSupervisorsResponseModel.fromJson(_response);

    expect(response.success, isTrue);
    expect(response.results, 1);
    expect(response.pagination?.currentPage, 1);
    expect(response.pagination?.perPage, 20);
    expect(response.data.single.user?.fullName, 'Mahmoud Supervisor');
    expect(response.data.single.activeAssignmentCount, 1);
    expect(response.data.single.assignments.single.classroom?.id, 'class-1');
    expect(response.data.single.assignments.single.assignedAt, isNotNull);
  });

  test('keeps a supervisor with no assignments', () {
    final json = Map<String, dynamic>.from(_response);
    json['data'] = [
      {'id': 'supervisor-2', 'assignments': <Object>[]},
    ];
    final response = GetSupervisorsResponseModel.fromJson(json);

    expect(response.data.single.id, 'supervisor-2');
    expect(response.data.single.assignments, isEmpty);
  });

  test('safely handles invalid nested values and numeric strings', () {
    final response = GetSupervisorsResponseModel.fromJson({
      'results': '2',
      'pagination': {'total': '2'},
      'data': [
        {
          'id': 'supervisor-1',
          'user': null,
          'curriculum': 'invalid',
          'activeAssignmentCount': '3',
          'assignments': [
            'invalid',
            {'assignedAt': 'invalid', 'classroom': null, 'grade': null},
          ],
          'createdAt': 'invalid',
        },
        'invalid',
      ],
    });

    expect(response.results, 2);
    expect(response.pagination?.total, 2);
    expect(response.data.single.user, isNull);
    expect(response.data.single.curriculum, isNull);
    expect(response.data.single.activeAssignmentCount, 3);
    expect(response.data.single.assignments, hasLength(1));
    expect(response.data.single.assignments.single.assignedAt, isNull);
  });

  for (final invalid in [null, 'invalid', <String, Object>{}]) {
    test('invalid assignments value $invalid becomes empty', () {
      final response = GetSupervisorsResponseModel.fromJson({
        'data': [
          {'assignments': invalid},
        ],
      });
      expect(response.data.single.assignments, isEmpty);
    });
  }
}

final _response = <String, dynamic>{
  'success': true,
  'results': 1,
  'pagination': {'currentPage': 1, 'perPage': 20, 'total': 1, 'lastPage': 1},
  'data': [
    {
      'id': 'supervisor-1',
      'phone': '01001002005',
      'user': {'id': 'user-1', 'fullName': 'Mahmoud Supervisor'},
      'curriculum': {'id': 'curriculum-1', 'name': 'Egyptian'},
      'activeAssignmentCount': 1,
      'assignments': [
        {
          'assignmentId': 'assignment-1',
          'classroom': {'id': 'class-1', 'name': 'First classroom'},
          'grade': {'id': 'grade-1', 'name': 'First grade'},
          'curriculum': {'id': 'curriculum-1', 'name': 'Egyptian'},
          'assignedAt': '2026-07-30T20:07:42.318Z',
        },
      ],
      'createdAt': '2026-07-30T20:05:39.695Z',
    },
  ],
};
