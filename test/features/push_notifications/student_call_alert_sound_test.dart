import 'dart:convert';
import 'dart:io';

import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/push_notifications/presentation/local_push_notifications.dart';
import 'package:bnan_app/features/push_notifications/presentation/student_call_alert_lifecycle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pluginChannel = MethodChannel(
    'dexterous.com/flutter/local_notifications',
  );
  const soundChannel = MethodChannel('bnan/notification_sound');
  late List<MethodCall> pluginCalls;
  late List<MethodCall> soundCalls;
  late List<String> timeline;
  String? launchPayload;

  setUp(() {
    pluginCalls = [];
    soundCalls = [];
    timeline = [];
    launchPayload = null;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(pluginChannel, (call) async {
      pluginCalls.add(call);
      timeline.add('plugin:${call.method}');
      if (call.method == 'initialize') return true;
      if (call.method == 'getNotificationAppLaunchDetails') {
        return <String, dynamic>{
          'notificationLaunchedApp': launchPayload != null,
          if (launchPayload != null)
            'notificationResponse': <String, dynamic>{
              'notificationId': 1128352844,
              'notificationResponseType': 0,
              'payload': launchPayload,
            },
        };
      }
      return null;
    });
    messenger.setMockMethodCallHandler(soundChannel, (call) async {
      soundCalls.add(call);
      timeline.add('sound:${call.method}');
      return null;
    });
  });

  tearDown(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(pluginChannel, null);
    messenger.setMockMethodCallHandler(soundChannel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('Android call alert delegates sound to the native service', () async {
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    await local.showNotification(
      _notification('notification-1', 'STUDENT_CALL_ALERT', callId: 'call-1'),
      appState: 'background',
    );

    expect(pluginCalls.where(_isShow), isEmpty);
    expect(soundCalls, isEmpty);
    await local.rejectStudentCall();
  });

  test('same callId rings once even when notificationId changes', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    await local.showNotification(
      _notification('notification-1', 'STUDENT_CALL_ALERT', callId: 'call-1'),
      appState: 'background',
    );
    await local.showNotification(
      _notification('notification-2', 'STUDENT_CALL_ALERT', callId: 'call-1'),
      appState: 'background',
    );

    expect(pluginCalls.where(_isShow), hasLength(1));
    await local.rejectStudentCall();
  });

  test('iOS notification and foreground ring use chat_ring', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    await local.showNotification(
      _notification('notification-1', 'STUDENT_CALL_ALERT', callId: 'call-1'),
      appState: 'background',
    );
    await local.rejectStudentCall();
    await local.showNotification(
      _notification('notification-1', 'STUDENT_CALL_ALERT', callId: 'call-2'),
      appState: 'foreground',
    );

    final shows = pluginCalls.where(_isShow).toList();
    expect(_shownDetails(shows.first)['sound'], 'chat_ring.wav');
    expect(_shownDetails(shows.last)['presentSound'], isFalse);
    expect(soundCalls.map((call) => call.method), contains('playChatRing'));
    await local.rejectStudentCall();
  });

  test('opening a call alert is not an implicit accept or reject', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    launchPayload = jsonEncode({'key': 'STUDENT_CALL_ALERT'});
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());

    expect(await local.initialPayload(), launchPayload);
    expect(pluginCalls.map((call) => call.method), isNot(contains('cancel')));
    expect(
      soundCalls.map((call) => call.method),
      isNot(contains('stopChatRing')),
    );
  });

  test('reject stops ring and allows a new call immediately', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    await local.showNotification(
      _notification(
        'same-notification',
        'STUDENT_CALL_ALERT',
        callId: 'call-1',
      ),
    );
    await local.rejectStudentCall();
    await local.showNotification(
      _notification(
        'same-notification',
        'STUDENT_CALL_ALERT',
        callId: 'call-2',
      ),
    );

    expect(local.studentCallStatus, StudentCallAlertStatus.ringing);
    expect(pluginCalls.where(_isShow), hasLength(2));
    expect(pluginCalls.map((call) => call.method), contains('cancel'));
    expect(
      timeline.indexOf('sound:stopChatRing'),
      lessThan(timeline.indexOf('plugin:cancel')),
    );
    await local.rejectStudentCall();
  });

  test('reject prevents the same callId from ringing again', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    final call = _notification(
      'same-notification',
      'STUDENT_CALL_ALERT',
      callId: 'call-1',
    );
    await local.showNotification(call);
    await local.rejectStudentCall();
    await local.showNotification(call);

    expect(pluginCalls.where(_isShow), hasLength(1));
    expect(local.studentCallStatus, StudentCallAlertStatus.rejected);
  });

  test('timeout produces noAnswer and cancels ring', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final local = LocalPushNotifications(
      FlutterLocalNotificationsPlugin(),
      studentCalls: StudentCallAlertLifecycle(
        duration: const Duration(milliseconds: 1),
      ),
    );
    await local.showNotification(
      _notification('notification-1', 'STUDENT_CALL_ALERT', callId: 'call-1'),
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(local.studentCallStatus, StudentCallAlertStatus.noAnswer);
    expect(pluginCalls.map((call) => call.method), contains('cancel'));
  });

  test('NEW_MESSAGE and CHAT_NUDGE keep their own sound paths', () async {
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    await local.showNotification(_notification('message', 'NEW_MESSAGE'));
    await local.showNotification(_notification('nudge', 'CHAT_NUDGE'));

    final shows = pluginCalls.where(_isShow).toList();
    expect(_shownDetails(shows.first)['channelId'], 'bnan_notifications');
    expect(_shownDetails(shows.first)['sound'], isNull);
    expect(_shownDetails(shows.last)['channelId'], 'bnan_nudge_silent_v1');
    expect(_shownDetails(shows.last)['sound'], isNull);
    expect(
      soundCalls.map((call) => call.method),
      contains('playNudgeNotificationSequence'),
    );
  });

  test('native iOS ring loops chat_ring and stops after 60 seconds', () {
    final swift = File(
      'ios/Runner/NotificationSoundPlayer.swift',
    ).readAsStringSync();
    expect(swift, contains('forResource: "chat_ring"'));
    expect(swift, contains('player.numberOfLoops = -1'));
    expect(swift, contains('deadline: .now() + 60'));
    expect(swift, contains('chatRingStop?.cancel()'));
    expect(swift, contains('chatRingPlayer?.stop()'));
    expect(swift, contains('forResource: "nudge_alert"'));
  });

  test('native Android ring is touch-independent and stops after 60 seconds', () {
    final kotlin = File(
      'android/app/src/main/kotlin/com/bnanacademy/app/StudentCallRingPlayer.kt',
    ).readAsStringSync();
    expect(kotlin, contains('isLooping = true'));
    expect(kotlin, contains('handler.postDelayed(stopTask, 60_000)'));
    expect(kotlin, contains('if (isPlaying) stop()'));
    expect(kotlin, contains('release()'));
    final service = File(
      'android/app/src/main/kotlin/com/bnanacademy/app/StudentCallAlertService.kt',
    ).readAsStringSync();
    expect(service, contains('setSound(null, null)'));
    expect(service, isNot(contains('FLAG_INSISTENT')));
    expect(service, contains('setContentIntent(open)'));
    expect(service, contains('finishCall(rejected = false)'));
    expect(service, contains('finishCall(rejected = true)'));
  });

  test('Android terminated flow is owned by a foreground service', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final receiver = File(
      'android/app/src/main/kotlin/com/bnanacademy/app/StudentCallFcmReceiver.kt',
    ).readAsStringSync();
    final service = File(
      'android/app/src/main/kotlin/com/bnanacademy/app/StudentCallAlertService.kt',
    ).readAsStringSync();

    expect(manifest, contains('android.permission.FOREGROUND_SERVICE'));
    expect(manifest, contains('FOREGROUND_SERVICE_MEDIA_PLAYBACK'));
    expect(manifest, contains('.StudentCallFcmReceiver'));
    expect(manifest, contains('.StudentCallAlertService'));
    expect(receiver, contains('FlutterFirebaseMessagingReceiver'));
    expect(receiver, contains('super.onReceive(context, intent)'));
    expect(manifest, contains('tools:node="remove"'));
    expect(receiver, contains('ContextCompat.startForegroundService'));
    expect(receiver, isNot(contains('NEW_MESSAGE')));
    expect(receiver, isNot(contains('CHAT_NUDGE')));
    expect(service, contains('startForeground('));
    expect(service, contains('setOngoing(true)'));
    expect(service, contains('ACTION_REJECT'));
    expect(service, contains('handler.postDelayed(timeout'));
    expect(service, contains('finishCall(rejected = false)'));
    expect(service, contains('finishCall(rejected = true)'));
  });

  test('Android and iOS package the identical chat_ring.wav', () {
    final android = File('android/app/src/main/res/raw/chat_ring.wav');
    final ios = File('ios/Runner/chat_ring.wav');
    expect(android.existsSync(), isTrue);
    expect(ios.existsSync(), isTrue);
    expect(android.readAsBytesSync(), ios.readAsBytesSync());
  });
}

AppNotification _notification(String id, String key, {String? callId}) =>
    AppNotification.fromJson({
      'notificationId': id,
      'key': key,
      if (callId != null) 'callId': callId,
      '_title': 'Title',
      '_body': 'Body',
    });

bool _isShow(MethodCall call) => call.method == 'show';

Map<String, dynamic> _shownDetails(MethodCall call) {
  final arguments = Map<String, dynamic>.from(call.arguments as Map);
  return Map<String, dynamic>.from(arguments['platformSpecifics'] as Map);
}
