import 'package:flutter/material.dart';

class AppTheme {
  static const String _vazirB = "vazirB";
  static const String _vazirM = "vazirM";
  static const String _vazirR = "vazirR";

  static final ThemeData lightTheme = ThemeData(
    fontFamily: _vazirM,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      secondary: Colors.white,
      outline: Colors.grey[300],
      outlineVariant: Colors.black,
      primary: Colors.black,
      error: Colors.red,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    textTheme: _textTheme(Brightness.light),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      secondary: Colors.grey[200]!,
      outline: Colors.grey[200],
      outlineVariant: Colors.black,
      primary: Colors.white,
      error: Colors.red,
    ),
    textTheme: _textTheme(Brightness.dark),
  );

  static TextTheme _textTheme(Brightness brightness) {
    final color = brightness == Brightness.light ? Colors.black : Colors.white;
    return TextTheme(
      titleLarge: TextStyle(
        color:
            brightness == Brightness.light
                ? const Color(0xff243443)
                : Colors.white,
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
      labelMedium: TextStyle(
        color: Colors.grey,
        fontFamily: _vazirM,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
