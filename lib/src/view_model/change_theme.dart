import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/helper/prefs.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      if (Preferences.containsKey(PrefsKey.isDark)) {
        final isDark = Preferences.getBool(PrefsKey.isDark) ?? false;
        emit(isDark ? ThemeMode.dark : ThemeMode.light);
      } else {
        emit(ThemeMode.light);
      }
    } catch (e, st) {
      debugPrint('ThemeCubit: failed to load prefs: $e\n$st');
    }
  }

  Future<void> changeTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);
    await _saveToPrefs(newMode == ThemeMode.dark);
  }

  Future<void> _saveToPrefs(bool isDark) async {
    try {
      await Preferences.setBool(PrefsKey.isDark, isDark);
    } catch (e) {
      debugPrint('ThemeCubit: failed to save prefs: $e');
    }
  }
}
