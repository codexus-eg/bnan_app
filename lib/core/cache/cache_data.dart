import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/cache/cache_key.dart';
import 'package:bnan_app/core/session/session_manager.dart';

abstract class CacheData {
  static bool? firstTime;
  static String? language;

  static Future<void> init() async {
    firstTime = CacheHelper.getData(key: CacheKey.firstTime);
    language = CacheHelper.getData(key: CacheKey.language) ?? 'ar';
  }

  static void setLanguage(String langCode) {
    language = langCode;
  }

  static Future<String?> get token async {
    return SessionManager.instance.getAccessToken();
  }

  static Future<bool> get isLoggedIn async {
    return SessionManager.instance.isLoggedIn();
  }
}