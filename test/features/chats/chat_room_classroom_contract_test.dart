import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('direct classroomId has priority over legacy classroom values', () {
    final room = _room({
      'classroomId': ' direct ',
      'classroom': {'id': 'legacy'},
    });
    expect(room.classroomId, 'direct');
  });

  test('legacy classroom identifier shapes remain supported', () {
    expect(
      _room({
        'classroom': {'id': 'id'},
      }).classroomId,
      'id',
    );
    expect(
      _room({
        'classroom': {'_id': '_id'},
      }).classroomId,
      '_id',
    );
    expect(_room({'classroom': ' text '}).classroomId, 'text');
  });

  test('empty, missing and non-string identifiers become null', () {
    expect(_room({'classroomId': '  '}).classroomId, isNull);
    expect(_room({}).classroomId, isNull);
    expect(_room({'classroomId': 123}).classroomId, isNull);
    expect(
      _room({
        'classroom': {'id': 123},
      }).classroomId,
      isNull,
    );
  });

  test('room types preserve the backend classroom contract', () {
    expect(_room({'type': 'classroom', 'classroomId': 'c'}).classroomId, 'c');
    expect(_room({'type': 'classroom'}).classroomId, isNull);
    for (final type in ['teacher_parent', 'teacher_student', 'support']) {
      final room = _room({'type': type});
      expect(room.type, type);
      expect(room.classroomId, isNull);
    }
  });

  test('classroom access contract is parsed directly', () {
    final private = _room({
      'type': 'classroom',
      'accessScope': 'private',
      'classroomSubjectId': ' classroom-subject ',
    });
    expect(private.accessScope, 'private');
    expect(private.classroomSubjectId, 'classroom-subject');

    final shared = _room({'type': 'classroom', 'accessScope': 'shared_group'});
    expect(shared.accessScope, 'shared_group');
    expect(shared.classroomSubjectId, isNull);
  });

  test('support room subtitle is the non-admin participant role', () {
    final room = _room({
      'type': 'support',
      'lastMessage': 'Do not show me as subtitle',
      'participants': [
        {
          'user': {'id': 'admin', 'role': 'admin'},
        },
        {
          'user': {'id': 'teacher', 'role': 'teacher'},
        },
      ],
    });

    expect(room.subtitle, 'معلم');
    expect(room.subtitle, isNot(room.lastMessage));
  });

  test(
    'support room without a participant role falls back to conversation',
    () {
      expect(_room({'type': 'support'}).subtitle, 'محادثة');
    },
  );
}

ChatRoomSummaryModel _room(Map<String, dynamic> values) {
  return ChatRoomSummaryModel.fromJson({
    'id': 'room-id',
    'displayName': 'Room',
    ...values,
  });
}
