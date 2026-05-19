
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late final SharedPreferences prefs;
 static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is int) {
      return await prefs.setInt(key, value);
    }
    if (value is String) {
      return await prefs.setString(key, value);
    }
    if (value is bool) {
      return  await prefs.setBool(key, value);
    }
    if (value is List<String>) {
    return await prefs.setStringList(key, value);
  }
    return await prefs.setDouble(key, value);
  }

  static dynamic getData({required String key}){
  return  prefs.get(key);
  }

  static Future removeData({required String key})async{
    return await prefs.remove(key);
  }
}
