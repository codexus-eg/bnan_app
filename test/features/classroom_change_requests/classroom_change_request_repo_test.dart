import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/data/repo/classroom_change_requests_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('admin request keeps the populated classroomSubject id', () {
    final request = ClassroomChangeRequestModel.fromJson({
      '_id': 'request-id',
      'classroomSubject': {
        '_id': 'classroom-subject-id',
        'subject': {'name': 'Math'},
      },
    });

    expect(request.classroomSubjectId, 'classroom-subject-id');
  });

  test('approve sends classroomSubject reference with adminNotes', () async {
    final api = _Api();
    await ClassroomChangeRequestsRepoImpl(api).approve(
      'request-id',
      classroomSubjectId: ' classroom-subject-id ',
      adminNotes: ' approved ',
    );

    expect(api.path, EndPoints.approveClassroomChangeRequest('request-id'));
    expect(api.data, {
      'classroomSubject': 'classroom-subject-id',
      'adminNotes': 'approved',
    });
  });

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

  test('cancel_subject sends the room classroomSubjectId', () async {
    final api = _Api();
    await ClassroomChangeRequestsRepoImpl(api).submitStudent(
      classroomId: 'classroom-id',
      classroomSubjectId: 'classroom-subject-id',
      notes: ' cancel subject ',
      requestType: 'cancel_subject',
    );
    expect(api.data, {
      'requestType': 'cancel_subject',
      'classroomSubjectId': 'classroom-subject-id',
      'notes': 'cancel subject',
    });
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
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    return {'message': 'ok'};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
