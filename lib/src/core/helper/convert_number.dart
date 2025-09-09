class ConvertNumber {
  static String normalizeDigits(String input) {
    final sb = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x06F0 && rune <= 0x06F9) {
        sb.writeCharCode(rune - 0x06F0 + 48);
      } else if (rune >= 0x0660 && rune <= 0x0669) {
        sb.writeCharCode(rune - 0x0660 + 48);
      } else {
        sb.writeCharCode(rune);
      }
    }
    return sb.toString();
  }
}
