import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import 'neon_moss.dart';
import 'tokens.dart';

class AppTheme {
  /// The light theme of EatUPB.
  static ThemeData get light {
    final baseLight = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.spaceGroteskTextTheme(baseLight.textTheme);

    // TODO: Define light theme
    return baseLight.copyWith(textTheme: textTheme);
  }

  /// The dark theme of ManaMetrics.
  static ThemeData get dark {
    final baseDark = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.spaceGroteskTextTheme(baseDark.textTheme);

    return ThemeData(
      useMaterial3: true,

      // Colors
      colorScheme: ColorScheme.fromSeed(
        seedColor: NeonMossDark.color.primary,
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        primary: NeonMossDark.color.primary,
        onPrimary: NeonMossDark.color.onPrimary,
        secondary: NeonMossDark.color.secondary,
      ),
      scaffoldBackgroundColor: NeonMossDark.color.backgroundDark,

      // Typography
      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: NeonMossDark.color.text,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: NeonMossDark.color.text,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: NeonMossDark.color.text,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: NeonMossDark.color.text,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          color: NeonMossDark.color.text,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          color: NeonMossDark.color.text,
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          color: NeonMossDark.color.text,
        ),
      ),

      // Extensions
      extensions: <ThemeExtension<dynamic>>[
        AppColorToken(
          primary: NeonMossDark.color.primary,
          onPrimary: NeonMossDark.color.onPrimary,
          secondary: NeonMossDark.color.secondary,
          backgroundDark: NeonMossDark.color.backgroundDark,
          background: NeonMossDark.color.background,
          backgroundLight: NeonMossDark.color.backgroundLight,
          text: NeonMossDark.color.text,
          textMuted: NeonMossDark.color.textMuted,
          highlight: NeonMossDark.color.highlight,
          border: NeonMossDark.color.border,
          borderMuted: NeonMossDark.color.borderMuted,
          error: NeonMossDark.color.error,
          warning: NeonMossDark.color.warning,
          success: NeonMossDark.color.success,
        ),
        AppRadiusToken(
          extraSmall: NeonMossDark.radius.extraSmall,
          small: NeonMossDark.radius.small,
          medium: NeonMossDark.radius.medium,
          large: NeonMossDark.radius.large,
          extraLarge: NeonMossDark.radius.extraLarge,
        ),
        AppSpaceToken(
          extraSmall: NeonMossDark.space.extraSmall,
          small: NeonMossDark.space.small,
          medium: NeonMossDark.space.medium,
          large: NeonMossDark.space.large,
          extraLarge: NeonMossDark.space.extraLarge,
        ),
      ],

      // <Widget>ThemeData Overrides (sorted alphabetically from here)
      appBarTheme: AppBarThemeData(
        backgroundColor: NeonMossDark.color.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      dividerTheme: DividerThemeData(
        color: NeonMossDark.color.borderMuted,
        thickness: 2,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: NeonMossDark.color.onPrimary,
          backgroundColor: NeonMossDark.color.primary,
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NeonMossDark.color.text,
          iconSize: 26,
        ),
      ),
    );
  }
}
