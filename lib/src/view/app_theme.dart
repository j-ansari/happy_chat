import 'package:flutter/material.dart';

class AppTheme {
  static const String _vazirB = "vazirB";
  static const String _vazirM = "vazirM";
  static const String _vazirR = "vazirR";

  static final ThemeData lightTheme = ThemeData(
    fontFamily: _vazirM,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.white,
      onBackground: Color(0xfffcedea),
      primary: Colors.black,
      onPrimary: Colors.black,
      secondary: Colors.white,
      outline: Colors.grey[300],
      outlineVariant: Colors.black,
      error: Colors.red,
      onSurface: Colors.black.withAlpha(30),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    textTheme: _textTheme(Brightness.light),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      onBackground: Colors.red.shade100,
      primary: Colors.white,
      onPrimary: Colors.grey,
      secondary: Colors.grey[200]!,
      outline: Colors.grey[200],
      outlineVariant: Colors.white,
      error: Colors.red,
      onSurface: Colors.black.withAlpha(60),
    ),
    textTheme: _textTheme(Brightness.dark),
  );

  static TextTheme _textTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final color = isLight ? Colors.black : Colors.white;
    return TextTheme(
      titleLarge: TextStyle(
        color: isLight ? const Color(0xff243443) : Colors.white,
        fontFamily: _vazirB,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(color: color, fontFamily: _vazirB, fontSize: 18),
      titleSmall: TextStyle(
        color: color,
        fontFamily: _vazirB,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: color, fontFamily: _vazirM, fontSize: 18),
      bodyMedium: TextStyle(color: color, fontFamily: _vazirM, fontSize: 16),
      bodySmall: TextStyle(color: color, fontFamily: _vazirR, fontSize: 14),
      labelLarge: TextStyle(
        color: isLight ? Colors.white : Colors.black,
        fontFamily: _vazirM,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      labelMedium: TextStyle(
        color: Colors.grey,
        fontFamily: _vazirM,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        color: Colors.black,
        fontFamily: _vazirM,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }
}
