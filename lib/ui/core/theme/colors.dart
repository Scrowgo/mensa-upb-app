import 'package:material_ui/material_ui.dart';

abstract class DarkGreenThemeColor {
  // Brand Colors
  static const Color primary = Color(0xFF80F20D);
  static const Color onPrimary = Colors.black;
  static const Color secondary = Colors.yellow;

  // Background Colors
  static const Color backgroundDark = Color(0xFF192210);
  static const Color background = Color(0xFF1A2A10);
  static const Color backgroundLight = Color.fromARGB(255, 30, 48, 18);

  // Text Colors
  static const Color text = Color(0xFFF2F2F2);
  static const Color textMuted = Color(0xFFB3B3B3);

  // Border Colors
  static const Color highlight = Color.fromARGB(255, 98, 185, 10);
  static const Color border = Color(0xFF2A3A20);
  static const Color borderMuted = Color(0xFF0F1A0A);

  // Alert Colors
  static const Color error = Colors.redAccent;
  static const Color warning = Colors.orangeAccent;
  static const Color success = Colors.lightGreenAccent;
}
