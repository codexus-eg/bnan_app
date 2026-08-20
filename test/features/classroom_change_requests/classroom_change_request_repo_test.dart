import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/classroom_change_requests/data/repo/classroom_change_requests_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('change_teacher sends classroomSubjectId, not subjectId', () async {
    final api = _Api();
    await ClassroomChangeRequestsRepoImpl(api).submitStudent(
      classroomId: 'classroom-id',
      classroomSubjectId: 'classroom-subject-id',
      notes: ' change teacher ',
    );
    expect(api.path, EndPoints.classroomChangeRequests('classroom-id'));
    expect(api.data, {
      'requestType': 'change_teacher',
      'classroomSubjectId': 'classroom-subject-id',
      'notes': 'change teacher',
    });
    expect((api.data! as Map).containsKey('subjectId'), isFalse);
  });
}

class _Api implements ApiConsumer {
  String? path;
  Object? data;

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    // ignore: avoid_print
    print('[ClassroomChangeRequestTest] request=$data');
    return {'message': 'ok'};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
