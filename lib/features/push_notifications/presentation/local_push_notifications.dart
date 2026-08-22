import 'dart:convert';

import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart' show MethodChannel;

class LocalPushNotifications {
  LocalPushNotifications(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;
  static const _chatRingNotificationId = 1128352844;
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
  static final _chatRingChannel = AndroidNotificationChannel(
    'bnan_chat_ring_v3',
    'Chat call alerts',
    description: 'Incoming chat call alerts',
    importance: Importance.max,
    sound: const RawResourceAndroidNotificationSound('chat_ring'),
    enableVibration: true,
    vibrationPattern: _nudgeAlertChannel.vibrationPattern,
    audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
  );
  static final Set<String> _shownChatRingIds = {};

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
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        if (payload?.isNotEmpty != true) return;
        if (_isChatRingPayload(payload!)) await stopChatRing();
        onPayload(payload);
      },
    );
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(_channel);
    await android?.createNotificationChannel(_nudgeChannel);
    await android?.createNotificationChannel(_nudgeAlertChannel);
    await android?.createNotificationChannel(_chatRingChannel);
  }

  Future<String?> initialPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    final payload = details?.notificationResponse?.payload;
    if (payload?.isNotEmpty == true && _isChatRingPayload(payload!)) {
      await stopChatRing();
    }
    return payload;
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
    String? appState,
  }) async {
    final key = notification.key.trim().toUpperCase();
    final isNudge = key == 'CHAT_NUDGE';
    final isChatRing = key == 'STUDENT_CALL_ALERT';
    if (isChatRing && !_claimChatRing(notification.id)) return;
    final isForegroundChatRing = isChatRing && appState == 'foreground';
    final useNudgeChannel = isNudge && !playNudgeLocally;
    await _plugin.show(
      id: isChatRing
          ? _chatRingNotificationId
          : notification.id.isEmpty
          ? notification.hashCode
          : notification.id.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          isChatRing
              ? 'bnan_chat_ring_v3'
              : useNudgeChannel
              ? 'bnan_nudge_alert_v2'
              : isNudge
              ? 'bnan_nudge_silent_v1'
              : 'bnan_notifications',
          isChatRing
              ? 'Chat call alerts'
              : useNudgeChannel
              ? 'Bnan long nudge alerts'
              : isNudge
              ? 'Bnan nudge notifications'
              : 'Bnan notifications',
          channelDescription: 'Bnan Academy notifications',
          icon: 'ic_notification',
          importance: isChatRing ? Importance.max : Importance.high,
          priority: isChatRing ? Priority.max : Priority.high,
          playSound: isChatRing || !isNudge || useNudgeChannel,
          sound: isChatRing
              ? const RawResourceAndroidNotificationSound('chat_ring')
              : useNudgeChannel
              ? const RawResourceAndroidNotificationSound('nudge_alert')
              : null,
          enableVibration: isChatRing || !isNudge || useNudgeChannel,
          vibrationPattern: isChatRing || useNudgeChannel
              ? _nudgeAlertChannel.vibrationPattern
              : null,
          audioAttributesUsage: isChatRing || useNudgeChannel
              ? AudioAttributesUsage.notificationRingtone
              : AudioAttributesUsage.notification,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound:
              (isChatRing && !isForegroundChatRing) ||
              !isNudge && !isChatRing ||
              useNudgeChannel,
          presentBadge: true,
          sound: isChatRing && !isForegroundChatRing
              ? 'chat_ring.wav'
              : useNudgeChannel
              ? 'nudge_alert.wav'
              : null,
        ),
      ),
      payload: jsonEncode(notification.toPayload()),
    );
    if (isNudge && playNudgeLocally) {
      await _soundChannel.invokeMethod<void>('playNudgeNotificationSequence');
    }
    if (isChatRing) {
      if (isForegroundChatRing && defaultTargetPlatform == TargetPlatform.iOS) {
        await _soundChannel.invokeMethod<void>('playChatRing');
      }
      debugPrint('[ChatRing] platform=${defaultTargetPlatform.name}');
      debugPrint('[ChatRing] appState=${appState ?? 'unknown'}');
      debugPrint('[ChatRing] sound/ring triggered');
    }
  }

  Future<void> stopChatRing() async {
    await _plugin.cancel(id: _chatRingNotificationId);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _soundChannel.invokeMethod<void>('stopChatRing');
    }
  }

  bool _isChatRingPayload(String payload) {
    try {
      final value = jsonDecode(payload);
      return value is Map &&
          value['key']?.toString().trim().toUpperCase() == 'STUDENT_CALL_ALERT';
    } catch (_) {
      return false;
    }
  }

  bool _claimChatRing(String id) {
    if (id.isEmpty) return true;
    if (!_shownChatRingIds.add(id)) return false;
    if (_shownChatRingIds.length > 100) {
      _shownChatRingIds.remove(_shownChatRingIds.first);
    }
    return true;
  }
}
