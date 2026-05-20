import 'package:bnan_app/core/app_routes/app_router.dart';
import 'package:bnan_app/core/cache/cache_data.dart';
import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/helper/theme_helper.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await CacheHelper.init();
  CacheData.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: ColorManager.white),
  );
  runApp(
    DevicePreview(
      // enabled: !kReleaseMode,
      storage: DevicePreviewStorage.none(),
      builder: (_) {
        return const BnanApp();
      },
    ),
  );
}

class BnanApp extends StatelessWidget {
  const BnanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('ar'),
      title: 'Bnan App',
      routerConfig: buildRouter(),
      theme: ThemeHelper.getTheme(),
    );
  }
}
