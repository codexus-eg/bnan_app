import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unassign uses one protected PATCH without body or query', () async {
    final api = _FakeApi();
    final result = await TeacherSubjectAssignmentRepoImpl(api)
        .unassignTeacherFromClassroom(
          teacherId: 'teacher-1',
          classroomId: 'classroom-1',
        );

    expect(result.isRight(), isTrue);
    expect(api.patchCalls, 1);
    expect(
      api.path,
      EndPoints.unassignTeacherFromClassroom(
        teacherId: 'teacher-1',
        classroomId: 'classroom-1',
      ),
    );
    expect(api.data, isNull);
    expect(api.query, isNull);
    expect(api.isProtected, isTrue);
    expect(
      result.getOrElse(() => throw StateError('failure')).data?.teacherId,
      'teacher-1',
    );
  });
}

class _FakeApi implements ApiConsumer {
  String? path;
  Object? data;
  Map<String, dynamic>? query;
  bool isProtected = false;
  int patchCalls = 0;

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    patchCalls++;
    this.path = path;
    this.data = data;
    query = queryParameter;
    this.isProtected = isProtected;
    return {
      'success': true,
      'data': {
        'teacher': 'teacher-1',
        'classroom': 'classroom-1',
        'deactivatedAssignments': 1,
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
