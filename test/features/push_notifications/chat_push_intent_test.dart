import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recognizes current backend chat contract with direct fields', () {
    final intent = ChatPushIntent.tryParse({
      'type': 'notification',
      'key': 'NEW_MESSAGE',
      'notificationType': 'chat',
      'notificationId': 'n1',
      'messageId': 'm1',
      'roomId': 'r1',
      'senderId': 's1',
    });
    expect(intent?.roomId, 'r1');
    expect(intent?.messageId, 'm1');
    expect(intent?.dedupKey, 'n1');
  });

  test('uses params only as safe fallback', () {
    final intent = ChatPushIntent.tryParse({
      'notificationType': 'chat',
      'params': '{"chatId":"r2","senderId":"s2"}',
    });
    expect(intent?.roomId, 'r2');
    expect(intent?.senderId, 's2');
    expect(
      ChatPushIntent.tryParse({'key': 'NEW_MESSAGE', 'params': 'invalid'}),
      isNull,
    );
  });

  test('does not use legacy type chat_message as discriminator', () {
    expect(
      ChatPushIntent.tryParse({'type': 'chat_message', 'roomId': 'r1'}),
      isNull,
    );
  });
}
