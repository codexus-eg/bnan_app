import 'package:bnan_app/bnan_app.dart';
import 'package:bnan_app/core/cache/cache_data.dart';
import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/cache/secure_cache_helper.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    await SecureCacheHelper.debugStorageTest();
  }
  await SessionManager.instance.loadSession();
  setupServiceLocator();
  await CacheHelper.init();
  await CacheData.init();
  await Hive.initFlutter();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: ColorManager.white),
  );
  runApp(
    DevicePreview(
      enabled: true,
      storage: DevicePreviewStorage.none(),
      builder: (_) {
        return const BnanApp();
      },
    ),
  );
}
