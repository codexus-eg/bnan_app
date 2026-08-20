import 'package:bnan_app/firebase_options.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/push_notifications/presentation/local_push_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<bool> initializeFirebase() async {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS)) {
    return false;
  }
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    return true;
  } catch (error) {
    if (kDebugMode) {
      debugPrint('Firebase configuration unavailable: ${error.runtimeType}');
    }
    return false;
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!await initializeFirebase() || message.notification != null) return;
  final data = <String, dynamic>{...message.data};
  if (data['key']?.toString().trim().toUpperCase() == 'STUDENT_CALL_ALERT') {
    data['screen'] = 'student_home';
  }
  final notification = AppNotification.fromJson(data);
  if (notification.id.isEmpty && notification.key.isEmpty) return;
  final local = LocalPushNotifications(FlutterLocalNotificationsPlugin());
  await local.initialize((_) {});
  await local.showNotification(notification, playNudgeLocally: false);
}
