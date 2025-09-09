import 'package:shared_preferences/shared_preferences.dart';

class PrefsKey {
  static const String token = "Token";
  static const String isDark = "IsDark";
}

class Preferences {
  static late SharedPreferences preferences;

  static bool? getBool(String key) => preferences.getBool(key);

  static String? getString(String key) => preferences.getString(key);

  static Future<bool> remove(String key) => preferences.remove(key);

  static Future<bool> setBool(String key, bool value) {
    return preferences.setBool(key, value);
  }

  static Future<bool> setString(String key, String value) {
    return preferences.setString(key, value);
  }

  static bool containsKey(String key) => preferences.containsKey(key);

  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
