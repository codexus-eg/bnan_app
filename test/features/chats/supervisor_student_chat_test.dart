import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_response_model.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo_impl.dart';
import 'package:bnan_app/features/chats/presentation/policies/supervisor_student_chat_access.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('opens supervisor student room with the student id', () async {
    final api = _Api();
    await ChatRepoImpl(api).openSupervisorStudentRoom(studentId: ' student-1 ');
    expect(api.path, EndPoints.supervisorStudentRoom);
    expect(api.data, {'studentId': 'student-1'});
    expect(api.isProtected, isTrue);
  });

  test('parses existing and newly created room responses', () {
    final existing = ChatRoomResponseModel.fromJson({
      'success': true,
      'created': false,
      'data': {'id': 'room-1', 'type': 'supervisor_student'},
    });
    final created = ChatRoomResponseModel.fromJson({
      'success': true,
      'data': {
        'created': true,
        'room': {'id': 'room-2', 'type': 'supervisor_student'},
      },
    });
    expect(existing.created, isFalse);
    expect(existing.room.id, 'room-1');
    expect(created.created, isTrue);
    expect(created.room.id, 'room-2');
  });

  test('uses backend supervisor student labels unchanged', () {
    final room = ChatRoomSummaryModel.fromJson({
      'id': 'room-1',
      'type': 'supervisor_student',
      'displayName': 'أحمد',
      'subtitle': 'طالب',
      'participants': [
        {'role': 'supervisor', 'name': 'fallback'},
      ],
    });
    expect(room.displayName, 'أحمد');
    expect(room.subtitle, 'طالب');
  });

  test('recognizes CHAT_ACCESS_DENIED only with a 403 response', () {
    expect(
      isChatAccessDenied(
        Failure(message: 'denied', statusCode: 403, code: 'CHAT_ACCESS_DENIED'),
      ),
      isTrue,
    );
    expect(
      isChatAccessDenied(
        Failure(message: 'CHAT_ACCESS_DENIED', statusCode: 500),
      ),
      isFalse,
    );
  });
}

class _Api implements ApiConsumer {
  String? path;
  Object? data;
  bool? isProtected;

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
    this.isProtected = isProtected;
    return {
      'success': true,
      'created': false,
      'data': {'id': 'room-1', 'type': 'supervisor_student'},
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
