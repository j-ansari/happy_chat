import 'package:flutter/material.dart';

extension AppSize on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorSchema => Theme.of(this).colorScheme;
}
