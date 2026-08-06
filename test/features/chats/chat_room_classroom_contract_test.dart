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
}

ChatRoomSummaryModel _room(Map<String, dynamic> values) {
  return ChatRoomSummaryModel.fromJson({
    'id': 'room-id',
    'displayName': 'Room',
    ...values,
  });
}
