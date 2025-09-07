import 'package:flutter/material.dart';

class AppTheme {
  static const String _vazirB = "_vazirB";
  static const String _vazirM = "_vazirM";
  static const String _vazirR = "_vazirR";

  static final ThemeData lightTheme = ThemeData(
    fontFamily: _vazirM,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    textTheme: _textTheme(Brightness.light),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: _textTheme(Brightness.dark),
  );

  static TextTheme _textTheme(Brightness brightness) {
    final color = brightness == Brightness.light ? Colors.black : Colors.white;
    return TextTheme(
      titleLarge: TextStyle(
        color: color,
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
    );
  }
}
