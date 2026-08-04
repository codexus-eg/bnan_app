import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('POST uses start endpoint and subjectId-only body', () async {
    final api = _RecordingApi(_response());
    final result = await StartSessionRepoImpl(
      api,
    ).startSession(classroomId: 'class-1', subjectId: 'subject-1');
    expect(api.path, EndPoints.startClassroomSession('class-1'));
    expect(api.data, {'subjectId': 'subject-1'});
    expect(result.isRight(), isTrue);
  });

  test(
    'parses session id, status, occurrence, time and meeting link',
    () async {
      final result = await StartSessionRepoImpl(
        _RecordingApi(_response()),
      ).startSession(classroomId: 'class-1', subjectId: 'subject-1');
      result.fold((_) => fail('Expected success'), (data) {
        expect(data.session.id, 'session-1');
        expect(data.session.status, 'starting');
        expect(data.session.activeOccurrence, isTrue);
        expect(data.session.startAt, DateTime.utc(2026, 8, 4, 12));
        expect(data.meetingLink, 'https://zoom.us/j/1');
      });
    },
  );

  test(
    'maps API exception through Failure without exposing exception',
    () async {
      final api = _RecordingApi(null)
        ..error = const AppException('CLASSROOM_ZOOM_NOT_CONFIGURED');
      final result = await StartSessionRepoImpl(
        api,
      ).startSession(classroomId: 'class-1', subjectId: 'subject-1');
      result.fold(
        (failure) => expect(failure.message, 'CLASSROOM_ZOOM_NOT_CONFIGURED'),
        (_) => fail('Expected failure'),
      );
    },
  );
}

Map<String, dynamic> _response() => {
  'success': true,
  'data': {
    'session': {
      '_id': 'session-1',
      'status': 'starting',
      'activeOccurrence': true,
      'startAt': '2026-08-04T12:00:00.000Z',
    },
    'meetingLink': 'https://zoom.us/j/1',
  },
};

class _RecordingApi implements ApiConsumer {
  _RecordingApi(this.response);
  final Object? response;
  Object? error, data;
  String? path;

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
    if (error != null) throw error!;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
