import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the complete supervisor assignment contract', () {
    final response = SupervisorAssignmentsResponseModel.fromJson({
      'success': true,
      'results': '1',
      'data': [_assignmentJson],
    });

    final assignment = response.data.single;
    expect(response.success, isTrue);
    expect(response.results, 1);
    expect(assignment.assignmentId, 'assignment-1');
    expect(assignment.classroom?.id, 'classroom-1');
    expect(assignment.grade?.name, 'Grade One');
    expect(assignment.curriculum?.name, 'Saudi2');
    expect(assignment.assignedBy?.email, 'admin@bnan.edu');
    expect(assignment.assignedAt, DateTime.parse('2026-08-02T17:49:39.416Z'));
  });

  test('invalid data becomes empty and invalid list entries are ignored', () {
    expect(SupervisorAssignmentsResponseModel.fromJson({}).data, isEmpty);
    expect(
      SupervisorAssignmentsResponseModel.fromJson({'data': {}}).data,
      isEmpty,
    );
    final response = SupervisorAssignmentsResponseModel.fromJson({
      'data': [
        null,
        1,
        'invalid',
        {'assignmentId': 'valid'},
      ],
    });
    expect(response.data.single.assignmentId, 'valid');
  });

  test('nested assignment objects are independently nullable', () {
    final response = SupervisorAssignmentsResponseModel.fromJson({
      'results': 2.9,
      'data': [
        {'assignmentId': 'assignment-1'},
      ],
    });
    final assignment = response.data.single;

    expect(response.results, 2);
    expect(assignment.classroom, isNull);
    expect(assignment.grade, isNull);
    expect(assignment.curriculum, isNull);
    expect(assignment.assignedBy, isNull);
    expect(assignment.assignedAt, isNull);
  });

  test('assign request preserves every classroom and exact API keys', () {
    const request = AssignSupervisorRequestModel(
      assignments: [
        AssignSupervisorClassroomRequestModel(classroomId: 'classroom-1'),
        AssignSupervisorClassroomRequestModel(classroomId: 'classroom-2'),
      ],
    );

    expect(request.toJson(), {
      'assignments': [
        {'classroom': 'classroom-1'},
        {'classroom': 'classroom-2'},
      ],
    });
    expect(request.toJson(), isNot(contains('supervisorId')));
    for (final item in request.toJson()['assignments'] as List) {
      expect(item, isNot(contains('classroomId')));
      expect(item, isNot(contains('grade')));
      expect(item, isNot(contains('curriculum')));
    }
  });

  test('parses supervisor unassign response and tolerates missing data', () {
    final response = UnassignSupervisorResponseModel.fromJson({
      'success': true,
      'data': {
        'supervisor': 'supervisor-1',
        'classroom': 'classroom-1',
        'isActive': false,
        'unassignedAt': '2026-08-02T16:46:21.896Z',
      },
    });

    expect(response.data?.supervisorId, 'supervisor-1');
    expect(response.data?.classroomId, 'classroom-1');
    expect(response.data?.isActive, isFalse);
    expect(
      response.data?.unassignedAt,
      DateTime.parse('2026-08-02T16:46:21.896Z'),
    );
    expect(UnassignSupervisorResponseModel.fromJson({}).data, isNull);
  });
}

final _assignmentJson = {
  'assignmentId': 'assignment-1',
  'classroom': {'id': 'classroom-1', 'name': 'Classroom One'},
  'grade': {'id': 'grade-1', 'name': 'Grade One'},
  'curriculum': {'id': 'curriculum-1', 'name': 'Saudi2'},
  'assignedAt': '2026-08-02T17:49:39.416Z',
  'assignedBy': {
    'id': 'admin-1',
    'fullName': 'Mahmoud Mansour',
    'email': 'admin@bnan.edu',
  },
};
