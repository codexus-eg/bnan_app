import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is int) return prefs.setInt(key, value);
    if (value is String) return prefs.setString(key, value);
    if (value is bool) return prefs.setBool(key, value);
    if (value is List<String>) return prefs.setStringList(key, value);
    if (value is double) return prefs.setDouble(key, value);

    throw ArgumentError('Unsupported cache value type: ${value.runtimeType}');
  }

  static dynamic getData({required String key}) {
    return prefs.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    return prefs.clear();
  }
}