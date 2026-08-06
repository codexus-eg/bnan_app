import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recordings_response.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summaries_response.dart';
import 'package:bnan_app/features/chats/data/repo/classroom_documents_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recordings parse normal and nullable data safely', () {
    final response = ClassroomRecordingsResponse.fromJson({
      'data': [
        {'sessionName': 'Math', 'recordingLink': 'https://zoom.us/x'},
        {'sessionName': null, 'recordingLink': null},
      ],
    });
    expect(response.items.first.sessionName, 'Math');
    expect(response.items.last.sessionName, isEmpty);
    expect(response.items.last.recordingLink, isNull);
    expect(ClassroomRecordingsResponse.fromJson({'data': null}).items, isEmpty);
    expect(ClassroomRecordingsResponse.fromJson({}).items, isEmpty);
  });

  test('summaries ignore invalid and nullable nested values safely', () {
    final response = ClassroomSummariesResponse.fromJson({
      'data': [
        {'sessionName': 'Math', 'summary': null},
        {
          'summary': {
            'title': null,
            'content': null,
            'docUrl': null,
            'nextSteps': [null, 7, '', ' Review '],
          },
        },
      ],
    });
    expect(response.items.first.summary, isNull);
    expect(response.items.last.summary?.title, isNull);
    expect(response.items.last.summary?.nextSteps, ['Review']);
    expect(ClassroomSummariesResponse.fromJson({'data': []}).items, isEmpty);
  });

  test(
    'repository uses protected classroom endpoints and parses empty',
    () async {
      final api = _FakeApi({'success': true, 'data': null});
      final repo = ClassroomDocumentsRepoImpl(api);
      final recordings = await repo.getRecordings('class-1');
      expect(api.path, '/classrooms/class-1/recordings');
      expect(api.protected, isTrue);
      expect(
        recordings.getOrElse(() => throw StateError('failure')).items,
        isEmpty,
      );
      await repo.getSummaries('class-1');
      expect(api.path, '/classrooms/class-1/summaries');
    },
  );

  test('failure is mapped and only explicit classroom id is parsed', () async {
    final api = _FakeApi(const AppException('unauthorized'))..throws = true;
    final result = await ClassroomDocumentsRepoImpl(api).getRecordings('c');
    expect(
      result.fold((failure) => failure.message, (_) => ''),
      'unauthorized',
    );
    expect(
      ChatRoomSummaryModel.fromJson({
        'id': 'room',
        'displayName': 'not-an-id',
        'classroom': {'_id': 'classroom'},
      }).classroomId,
      'classroom',
    );
    expect(
      ChatRoomSummaryModel.fromJson({'displayName': 'classroom'}).classroomId,
      isNull,
    );
  });
}

class _FakeApi implements ApiConsumer {
  _FakeApi(this.response);
  final Object response;
  String? path;
  bool protected = false;
  bool throws = false;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    if (throws) throw response;
    this.path = path;
    protected = isProtected;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
