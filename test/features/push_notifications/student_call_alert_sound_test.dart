import 'dart:convert';
import 'dart:io';

import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/push_notifications/presentation/local_push_notifications.dart';
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
  String? launchPayload;

  setUp(() {
    pluginCalls = [];
    soundCalls = [];
    launchPayload = null;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(pluginChannel, (call) async {
      pluginCalls.add(call);
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

  test('Android call alert uses the new insistent 15-second ring', () async {
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    await local.showNotification(
      _notification('android-ring', 'STUDENT_CALL_ALERT'),
      appState: 'background',
    );

    final details = _shownDetails(pluginCalls.singleWhere(_isShow));
    expect(details['channelId'], 'bnan_chat_ring_v3');
    expect(details['sound'], 'chat_ring');
    expect(details['timeoutAfter'], 15000);
    expect(details['additionalFlags'], [4]);
  });

  test('same STUDENT_CALL_ALERT notificationId rings once', () async {
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    final alert = _notification('duplicate-ring', 'STUDENT_CALL_ALERT');
    await local.showNotification(alert, appState: 'background');
    await local.showNotification(alert, appState: 'background');

    expect(pluginCalls.where(_isShow), hasLength(1));
  });

  test('iOS notification and foreground ring use chat_ring', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
    await local.showNotification(
      _notification('ios-background-ring', 'STUDENT_CALL_ALERT'),
      appState: 'background',
    );
    await local.showNotification(
      _notification('ios-foreground-ring', 'STUDENT_CALL_ALERT'),
      appState: 'foreground',
    );

    final shows = pluginCalls.where(_isShow).toList();
    expect(_shownDetails(shows.first)['sound'], 'chat_ring.wav');
    expect(_shownDetails(shows.last)['presentSound'], isFalse);
    expect(soundCalls.map((call) => call.method), contains('playChatRing'));
  });

  test('opening a call alert stops its current ring', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    launchPayload = jsonEncode({'key': 'STUDENT_CALL_ALERT'});
    final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());

    expect(await local.initialPayload(), launchPayload);
    expect(pluginCalls.map((call) => call.method), contains('cancel'));
    expect(soundCalls.map((call) => call.method), contains('stopChatRing'));
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

  test('native iOS ring loops chat_ring and stops after 15 seconds', () {
    final swift = File(
      'ios/Runner/NotificationSoundPlayer.swift',
    ).readAsStringSync();
    expect(swift, contains('forResource: "chat_ring"'));
    expect(swift, contains('player.numberOfLoops = -1'));
    expect(swift, contains('deadline: .now() + 15'));
    expect(swift, contains('chatRingStop?.cancel()'));
    expect(swift, contains('chatRingPlayer?.stop()'));
    expect(swift, contains('forResource: "nudge_alert"'));
  });

  test('Android and iOS package the identical chat_ring.wav', () {
    final android = File('android/app/src/main/res/raw/chat_ring.wav');
    final ios = File('ios/Runner/chat_ring.wav');
    expect(android.existsSync(), isTrue);
    expect(ios.existsSync(), isTrue);
    expect(android.readAsBytesSync(), ios.readAsBytesSync());
  });
}

AppNotification _notification(String id, String key) =>
    AppNotification.fromJson({
      'notificationId': id,
      'key': key,
      '_title': 'Title',
      '_body': 'Body',
    });

bool _isShow(MethodCall call) => call.method == 'show';

Map<String, dynamic> _shownDetails(MethodCall call) {
  final arguments = Map<String, dynamic>.from(call.arguments as Map);
  return Map<String, dynamic>.from(arguments['platformSpecifics'] as Map);
}
