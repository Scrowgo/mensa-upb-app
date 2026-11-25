import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import 'tokens.dart';

class DarkGreenTheme {
  static Map<ColorToken, Color> get colors => {
    // Brand Colors
    AppColorToken.primary.token: Color(0xFF80F20D),
    AppColorToken.onPrimary.token: Colors.black,
    AppColorToken.secondary.token: Colors.yellow,

    // Background Colors
    AppColorToken.backgroundDark.token: Color(0xFF192210),
    AppColorToken.background.token: Color(0xFF1A2A10),
    AppColorToken.backgroundLight.token: Color.fromARGB(255, 30, 48, 18),

    // Text Colors
    AppColorToken.text.token: Color(0xFFF2F2F2),
    AppColorToken.textMuted.token: Color(0xFFB3B3B3),

    // Border Colors
    AppColorToken.highlight.token: Color.fromARGB(255, 98, 185, 10),
    AppColorToken.border.token: Color(0xFF2A3A20),
    AppColorToken.borderMuted.token: Color(0xFF0F1A0A),

    // Alert Colors
    AppColorToken.error.token: Colors.redAccent,
    AppColorToken.warning.token: Colors.orangeAccent,
    AppColorToken.success.token: Colors.lightGreenAccent,
  };

  static Map<TextStyleToken, TextStyle> get textStyles => {
    AppTextStyleToken.appTitle.token: const .new(
      fontSize: 22,
      fontWeight: .bold,
      fontFamily: 'SpaceGrotesk',
    ),
    AppTextStyleToken.headline.token: const .new(
      fontSize: 18,
      fontWeight: .bold,
      fontFamily: 'SpaceGrotesk',
    ),
    AppTextStyleToken.body.token: const .new(
      fontSize: 14,
      fontFamily: 'SpaceGrotesk',
    ),
    AppTextStyleToken.button.token: const .new(
      fontSize: 14,
      fontFamily: 'SpaceGrotesk',
    ),
  };

  static Map<RadiusToken, Radius> get radii => {
    AppRadiusToken.medium.token: const .circular(12),
    AppRadiusToken.large.token: const .circular(100),
  };

  static Map<SpaceToken, double> get spaces => {
    AppSpaceToken.medium.token: 16,
    AppSpaceToken.large.token: 24,
  };
}
