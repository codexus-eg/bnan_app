import 'package:bnan_app/features/teacher_request_groups/data/models/accepted_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_request_groups/data/models/teacher_requests_pagination_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('request model safely parses nullable and unexpected values', () {
    final model = RegistrationRequestModel.fromJson({
      'requestId': 7,
      'studentName': null,
      'notes': ' ',
      'requestedAt': false,
    });

    expect(model.requestId, '7');
    expect(model.studentName, isEmpty);
    expect(model.notes, isNull);
    expect(model.requestedAt, isNull);
  });

  test('pagination safely handles missing data and lastPage zero', () {
    final missing = TeacherRequestsPaginationModel.fromJson(null);
    final zero = TeacherRequestsPaginationModel.fromJson({
      'currentPage': '1',
      'lastPage': 0,
    });

    expect(missing.currentPage, 0);
    expect(zero.lastPage, 0);
    expect(zero.hasNextPage, isFalse);
  });

  test('accept response retains classroom and chat room ids', () {
    final result = AcceptedTeacherRequestModel.fromJson({
      'data': {
        'requestId': 'request-1',
        'classroom': {'id': 'classroom-1'},
        'chatRoom': {'id': 'chat-1'},
      },
    });

    expect(result.classroomId, 'classroom-1');
    expect(result.chatRoomId, 'chat-1');
  });
}
