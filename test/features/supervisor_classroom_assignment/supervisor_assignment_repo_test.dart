import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeApi api;
  late SupervisorAssignmentRepoImpl repo;

  setUp(() {
    api = _FakeApi();
    repo = SupervisorAssignmentRepoImpl(api);
  });

  test('list uses exactly one protected GET to supervisors', () async {
    final result = await repo.getSupervisors();

    expect(result.isRight(), isTrue);
    expect(
      result.getOrElse(() => throw StateError('failure')),
      isA<GetSupervisorsResponseModel>(),
    );
    expect(api.getCalls, 1);
    expect(api.path, EndPoints.supervisors);
    expect(api.data, isNull);
    expect(api.query, isNull);
  });

  test('get uses one protected GET without body or query', () async {
    final result = await repo.getSupervisorAssignments(
      supervisorId: 'supervisor-1',
    );

    expect(result.isRight(), isTrue);
    expect(
      result.getOrElse(() => throw StateError('failure')),
      isA<SupervisorAssignmentsResponseModel>(),
    );
    expect(api.getCalls, 1);
    expect(api.path, EndPoints.supervisorAssignments('supervisor-1'));
    expect(api.data, isNull);
    expect(api.query, isNull);
  });

  test('assign uses the GET path and posts every classroom', () async {
    const request = AssignSupervisorRequestModel(
      assignments: [
        AssignSupervisorClassroomRequestModel(classroomId: 'classroom-1'),
        AssignSupervisorClassroomRequestModel(classroomId: 'classroom-2'),
      ],
    );
    final result = await repo.assignSupervisorToClassrooms(
      supervisorId: 'supervisor-1',
      request: request,
    );

    expect(result.isRight(), isTrue);
    expect(
      result.getOrElse(() => throw StateError('failure')),
      isA<SupervisorAssignmentsResponseModel>(),
    );
    expect(api.postCalls, 1);
    expect(api.path, EndPoints.supervisorAssignments('supervisor-1'));
    expect(api.data, request.toJson());
    expect(api.query, isNull);
  });

  test('unassign uses one protected PATCH without body or query', () async {
    api.response = {
      'success': true,
      'data': {
        'supervisor': 'supervisor-1',
        'classroom': 'classroom-1',
        'isActive': false,
      },
    };
    final result = await repo.unassignSupervisorFromClassroom(
      supervisorId: 'supervisor-1',
      classroomId: 'classroom-1',
    );

    expect(result.isRight(), isTrue);
    expect(
      result.getOrElse(() => throw StateError('failure')),
      isA<UnassignSupervisorResponseModel>(),
    );
    expect(api.patchCalls, 1);
    expect(
      api.path,
      EndPoints.unassignSupervisorFromClassroom(
        supervisorId: 'supervisor-1',
        classroomId: 'classroom-1',
      ),
    );
    expect(api.data, isNull);
    expect(api.query, isNull);
  });
}

class _FakeApi implements ApiConsumer {
  String? path;
  Object? data;
  Map<String, dynamic>? query;
  Object response = {'success': true, 'results': 0, 'data': <Object>[]};
  int getCalls = 0;
  int postCalls = 0;
  int patchCalls = 0;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    getCalls++;
    _capture(path, data, queryParameter);
    return response;
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    postCalls++;
    _capture(path, data, queryParameter);
    return response;
  }

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    patchCalls++;
    _capture(path, data, queryParameter);
    return response;
  }

  void _capture(
    String path,
    Object? data,
    Map<String, dynamic>? queryParameter,
  ) {
    this.path = path;
    this.data = data;
    query = queryParameter;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
