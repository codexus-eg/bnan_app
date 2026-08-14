import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:bnan_app/features/notifications/domain/recent_notification_ids.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deduplicates IDs with bounded cache', () {
    final recent = RecentNotificationIds(capacity: 2);
    expect(recent.claim('n1'), isTrue);
    expect(recent.claim('n1'), isFalse);
    recent.claim('n2');
    recent.claim('n3');
    expect(recent.claim('n1'), isTrue);
  });

  test('resolves chat and safely falls back for unknown screen', () {
    final service = NotificationNavigationService(SessionManager.instance);
    expect(
      service.resolve(_value('chat_room', id: 'room/1')),
      '/chat/room%2F1',
    );
    expect(service.resolve(_value('future_screen')), '/notification');
  });
}

AppNotification _value(String screen, {String? id}) =>
    AppNotification.fromJson({
      'id': 'n1',
      'key': 'ANY',
      'resource': {'id': id},
      'navigation': {'screen': screen},
    });
