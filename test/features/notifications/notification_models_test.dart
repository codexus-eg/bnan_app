import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/data/models/notifications_page.dart';
import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses unknown values and malformed params without throwing', () {
    final value = AppNotification.fromJson({
      'id': 'n1',
      'type': 'future_type',
      'key': 'FUTURE_EVENT',
      'navigation': {'screen': 'future_screen', 'params': '{bad json'},
      'resource': null,
      'createdAt': 'not-a-date',
    });
    expect(value.id, 'n1');
    expect(value.navigation.params, isEmpty);
    expect(value.createdAt, isNull);
  });

  test('parses nested pagination response and unread count', () {
    final page = NotificationsPage.fromJson({
      'data': {
        'notifications': [
          {'id': 'n1', 'title': 'Title'},
        ],
        'unreadCount': 4,
        'pagination': {'page': 1, 'totalPages': 2},
      },
    });
    expect(page.items.single.id, 'n1');
    expect(page.unreadCount, 4);
    expect(page.hasNext, isTrue);
  });

  test('FCM JSON params preserve room id and room name', () {
    final value = AppNotification.fromJson({
      'notificationId': 'n1',
      'key': 'NEW_MESSAGE',
      'params': '{"roomId":"1","roomName":"Mathematics"}',
    });
    expect(value.navigation.params['roomId'], '1');
    expect(value.navigation.params['roomName'], 'Mathematics');
  });

  test('legacy chat push intent preserves chatName alias', () {
    final value = ChatPushIntent.tryParse({
      'key': 'NEW_MESSAGE',
      'params': '{"roomId":"1","chatName":"Mathematics"}',
    });
    expect(value?.roomName, 'Mathematics');
  });
}
