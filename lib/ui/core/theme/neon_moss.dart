import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

/// Dark variant of NeonMoss theme
abstract class NeonMossDark {
  static AppColorToken get color => AppColorToken(
    primary: Color(0xFF80F20D),
    onPrimary: Colors.black,
    secondary: Colors.amberAccent,
    backgroundDark: Color(0xFF0F1A0A),
    background: Color(0xFF192210),
    backgroundLight: Color(0xFF1A2A10),
    text: Color(0xFFF2F2F2),
    textMuted: Color(0xFFB3B3B3),
    highlight: Colors.lightGreen,
    border: Color(0xFF2A3A20),
    borderMuted: Colors.green.shade900,
    error: Colors.redAccent,
    warning: Colors.orangeAccent,
    success: Colors.lightGreenAccent,
  );

  static AppRadiusToken get radius => AppRadiusToken(
    extraSmall: 10,
    small: 16,
    medium: 20,
    large: 24,
    extraLarge: 30,
  );

  static AppSpaceToken get space => AppSpaceToken(
    extraSmall: 4,
    small: 8,
    medium: 10,
    large: 12,
    extraLarge: 16,
  );
}
