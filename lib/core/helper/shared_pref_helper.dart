import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  // initialize instance
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setInt(String key, int value) async {
    await init();
    return _prefs!.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  static Future<bool> setString(String key, String value) async {
    await init();
    return _prefs!.setString(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    await init();
    return _prefs!.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    await init();
    return _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    await init();
    return _prefs!.clear();
  }

  static Future<void> saveDataByKey(String s, String name) async {}
}
