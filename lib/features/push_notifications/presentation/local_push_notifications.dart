import 'dart:convert';

import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotifications {
  LocalPushNotifications(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;
  static const _channel = AndroidNotificationChannel(
    'bnan_notifications',
    'Bnan notifications',
    description: 'Bnan Academy notifications',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize(ValueChanged<String> onPayload) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload?.isNotEmpty == true) onPayload(payload!);
      },
    );
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(_channel);
  }

  Future<String?> initialPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    return details?.didNotificationLaunchApp == true
        ? details?.notificationResponse?.payload
        : null;
  }

  Future<void> show(ChatPushIntent intent, Map<String, dynamic> data) {
    final payload = jsonEncode({
      ...data,
      '_title': intent.title,
      '_body': intent.body,
    });
    return _plugin.show(
      id: intent.dedupKey.hashCode,
      title: intent.title,
      body: intent.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'bnan_notifications',
          'Bnan notifications',
          channelDescription: 'Bnan Academy notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(presentSound: true),
      ),
      payload: payload,
    );
  }

  Future<void> showNotification(AppNotification notification) => _plugin.show(
    id: notification.id.isEmpty
        ? notification.hashCode
        : notification.id.hashCode,
    title: notification.title,
    body: notification.body,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'bnan_notifications',
        'Bnan notifications',
        channelDescription: 'Bnan Academy notifications',
        icon: 'ic_notification',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
      ),
    ),
    payload: jsonEncode(notification.toPayload()),
  );
}
