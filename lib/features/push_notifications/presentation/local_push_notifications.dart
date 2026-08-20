import 'dart:convert';
import 'dart:typed_data';

import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart' show MethodChannel;

class LocalPushNotifications {
  LocalPushNotifications(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;
  static const _soundChannel = MethodChannel('bnan/notification_sound');
  static const _channel = AndroidNotificationChannel(
    'bnan_notifications',
    'Bnan notifications',
    description: 'Bnan Academy notifications',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );
  static const _nudgeChannel = AndroidNotificationChannel(
    'bnan_nudge_silent_v1',
    'Bnan nudge notifications',
    description: 'Bnan Academy nudge notifications',
    importance: Importance.max,
    playSound: false,
    enableVibration: false,
  );
  static final _nudgeAlertChannel = AndroidNotificationChannel(
    'bnan_nudge_alert_v2',
    'Bnan long nudge alerts',
    description: 'Bnan Academy long student nudge alerts',
    importance: Importance.max,
    sound: const RawResourceAndroidNotificationSound('nudge_alert'),
    enableVibration: true,
    vibrationPattern: Int64List.fromList(const [
      0,
      500,
      300,
      500,
      300,
      500,
      300,
      500,
      300,
      500,
      300,
      500,
      300,
      500,
      300,
      500,
    ]),
    audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
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
    await android?.createNotificationChannel(_nudgeChannel);
    await android?.createNotificationChannel(_nudgeAlertChannel);
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
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  Future<void> showNotification(
    AppNotification notification, {
    bool playNudgeLocally = true,
  }) async {
    final isNudge = notification.key.trim().toUpperCase() == 'CHAT_NUDGE';
    final useNudgeChannel = isNudge && !playNudgeLocally;
    await _plugin.show(
      id: notification.id.isEmpty
          ? notification.hashCode
          : notification.id.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          useNudgeChannel
              ? 'bnan_nudge_alert_v2'
              : isNudge
              ? 'bnan_nudge_silent_v1'
              : 'bnan_notifications',
          useNudgeChannel
              ? 'Bnan long nudge alerts'
              : isNudge
              ? 'Bnan nudge notifications'
              : 'Bnan notifications',
          channelDescription: 'Bnan Academy notifications',
          icon: 'ic_notification',
          importance: Importance.high,
          priority: Priority.high,
          playSound: !isNudge || useNudgeChannel,
          sound: useNudgeChannel
              ? const RawResourceAndroidNotificationSound('nudge_alert')
              : null,
          enableVibration: !isNudge || useNudgeChannel,
          vibrationPattern: useNudgeChannel
              ? _nudgeAlertChannel.vibrationPattern
              : null,
          audioAttributesUsage: useNudgeChannel
              ? AudioAttributesUsage.notificationRingtone
              : AudioAttributesUsage.notification,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: !isNudge || useNudgeChannel,
          presentBadge: true,
          sound: useNudgeChannel ? 'nudge_alert.wav' : null,
        ),
      ),
      payload: jsonEncode(notification.toPayload()),
    );
    if (isNudge && playNudgeLocally) {
      await _soundChannel.invokeMethod<void>('playNudgeNotificationSequence');
    }
  }
}
