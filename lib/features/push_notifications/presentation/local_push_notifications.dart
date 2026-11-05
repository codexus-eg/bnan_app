import 'dart:async';
import 'dart:convert';

import 'package:bnan_app/features/push_notifications/data/models/chat_push_intent.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/push_notifications/presentation/student_call_alert_lifecycle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart' show MethodChannel;

class LocalPushNotifications {
  LocalPushNotifications(
    this._plugin, {
    StudentCallAlertLifecycle? studentCalls,
  }) : _studentCalls = studentCalls ?? StudentCallAlertLifecycle();
  final FlutterLocalNotificationsPlugin _plugin;
  final StudentCallAlertLifecycle _studentCalls;
  static const _chatRingNotificationId = 1128352844;
  static const _chatRingDurationMs = 60000;
  static const _rejectAction = 'student_call_reject';
  static const _rejectLabel = 'Reject';
  static const _callCategory = 'student_call_alert';
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
  StudentCallAlertStatus? get studentCallStatus => _studentCalls.status;

  Future<void> initialize(ValueChanged<String> onPayload) async {
    await _plugin.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              _callCategory,
              actions: [
                DarwinNotificationAction.plain(
                  _rejectAction,
                  _rejectLabel,
                  options: {
                    DarwinNotificationActionOption.foreground,
                    DarwinNotificationActionOption.destructive,
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        if (response.actionId == _rejectAction && _isChatRingPayload(payload)) {
          await rejectStudentCall();
          return;
        }
        if (_isChatRingPayload(payload)) {
          await _resumeStudentCall(payload);
        }
        onPayload(payload);
      },
      onDidReceiveBackgroundNotificationResponse:
          studentCallNotificationResponseBackground,
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
    if (details?.didNotificationLaunchApp != true) return null;
    final payload = details?.notificationResponse?.payload;
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
          icon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
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
    final useNativeAndroidRing =
        isChatRing && defaultTargetPlatform == TargetPlatform.android;
    if (useNativeAndroidRing) {
      debugPrint(
        '[ChatRing] Android notification/ring owned by native service',
      );
      return;
    }
    if (isChatRing &&
        !_studentCalls.start(notification.callAttemptId, _timeoutStudentCall)) {
      return;
    }
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
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          importance: isChatRing ? Importance.max : Importance.high,
          priority: isChatRing ? Priority.max : Priority.high,
          playSound:
              isChatRing && !isForegroundChatRing && !useNativeAndroidRing ||
              !isNudge && !isChatRing ||
              useNudgeChannel,
          sound: isChatRing && !useNativeAndroidRing
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
          timeoutAfter: isChatRing ? _chatRingDurationMs : null,
          additionalFlags: null,
          autoCancel: !isChatRing,
          actions: isChatRing
              ? [
                  AndroidNotificationAction(
                    _rejectAction,
                    _rejectLabel,
                    showsUserInterface: true,
                    cancelNotification: true,
                  ),
                ]
              : null,
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
          categoryIdentifier: isChatRing ? _callCategory : null,
        ),
      ),
      payload: jsonEncode(notification.toPayload()),
    );
    if (isNudge && playNudgeLocally) {
      await _soundChannel.invokeMethod<void>('playNudgeNotificationSequence');
    }
    if (isChatRing) {
      if (isForegroundChatRing && _canPlayNativeChatRing) {
        await _soundChannel.invokeMethod<void>('playChatRing');
      }
      debugPrint('[ChatRing] platform=${defaultTargetPlatform.name}');
      debugPrint('[ChatRing] appState=${appState ?? 'unknown'}');
      debugPrint('[ChatRing] sound/ring triggered');
    }
  }

  Future<void> stopChatRing() async {
    if (_canStopNativeChatRing) {
      try {
        await _soundChannel.invokeMethod<void>('stopChatRing');
      } catch (error) {
        if (kDebugMode) {
          debugPrint('Chat ring stop failed: ${error.runtimeType}');
        }
      }
    }
    await _plugin.cancel(id: _chatRingNotificationId);
  }

  Future<void> rejectStudentCall() async {
    _studentCalls.reject();
    await stopChatRing();
  }

  Future<void> _timeoutStudentCall() => stopChatRing();

  bool get _canPlayNativeChatRing =>
      defaultTargetPlatform == TargetPlatform.iOS;

  bool get _canStopNativeChatRing =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _resumeStudentCall(String payload) async {
    final value = jsonDecode(payload);
    if (value is! Map) return;
    final notification = AppNotification.fromJson(
      Map<String, dynamic>.from(value),
    );
    if (_studentCalls.status != StudentCallAlertStatus.ringing &&
        !_studentCalls.start(notification.callAttemptId, _timeoutStudentCall)) {
      return;
    }
    if (_canPlayNativeChatRing) {
      await _soundChannel.invokeMethod<void>('playChatRing');
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
}

@pragma('vm:entry-point')
Future<void> studentCallNotificationResponseBackground(
  NotificationResponse response,
) async {
  if (response.actionId != LocalPushNotifications._rejectAction) return;
  await LocalPushNotifications(
    FlutterLocalNotificationsPlugin(),
  ).rejectStudentCall();
}
