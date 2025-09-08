import 'package:flutter/services.dart';

class CustomRegexHandler extends TextInputFormatter {
  final RegExp regex;

  const CustomRegexHandler({required this.regex});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length >= oldValue.text.length) {
      final newChar = newValue.text.replaceFirst(oldValue.text, '');
      if (!regex.hasMatch(newChar)) {
        return oldValue;
      }
    }
    return newValue;
  }
}

