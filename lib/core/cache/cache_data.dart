import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/cache/cache_key.dart';

abstract class CacheData {
  static bool? firstTime;
  static String? language;
  static String? token;

  static void init() {
    final langCode = CacheHelper.getData(key: CacheKey.language);
    language = langCode ?? 'ar';
    token = CacheHelper.getData(key: CacheKey.token);
  }

  static void setLanguage(String langCode) {
    language = langCode;
  }
}
