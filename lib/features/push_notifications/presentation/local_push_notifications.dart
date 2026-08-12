import 'dart:convert';

import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotifications {
  LocalPushNotifications(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;
  static const _channel = AndroidNotificationChannel(
    'chat_messages',
    'Chat messages',
    description: 'New chat message notifications',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize(ValueChanged<String> onPayload) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher'),
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
          'chat_messages',
          'Chat messages',
          channelDescription: 'New chat message notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(presentSound: true),
      ),
      payload: payload,
    );
  }
}
