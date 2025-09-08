import 'package:shared_preferences/shared_preferences.dart';

class PrefsKey {
  static const String token = "Token";
}

class Preferences {
  static late SharedPreferences preferences;

  static bool? getBool(String key) {
    return preferences.getBool(key);
  }

  static String? getString(String key) {
    return preferences.getString(key);
  }

  static Future<bool> remove(String key) {
    return preferences.remove(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return preferences.setBool(key, value);
  }

  static Future<bool> setString(String key, String value) {
    return preferences.setString(key, value);
  }

  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
