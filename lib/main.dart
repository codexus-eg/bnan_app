import 'package:bnan_app/bnan_app.dart';
import 'package:bnan_app/core/cache/cache_data.dart';
import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/push_notifications/firebase_bootstrap.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  if (kDebugMode) {
    await SecureCacheHelper.debugStorageTest();
  }
  await SessionManager.instance.loadSession();
  await CacheHelper.init();
  await CacheData.init();
  await Hive.initFlutter();
  final firebaseAvailable = await initializeFirebase();
  if (firebaseAvailable) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  setupServiceLocator(firebaseAvailable: firebaseAvailable);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: ColorManager.white),
  );
  runApp(
    const BnanApp(),
  );
}
