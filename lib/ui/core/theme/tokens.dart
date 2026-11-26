import 'dart:ui';
import 'package:material_ui/material_ui.dart';

class AppColorToken extends ThemeExtension<AppColorToken> {
  // Brand Colors
  final Color primary;
  final Color onPrimary;
  final Color secondary;

  // Background Colors
  final Color backgroundDark;
  final Color background;
  final Color backgroundLight;

  // Text Colors
  final Color text;
  final Color textMuted;

  // Border Colors
  final Color highlight;
  final Color border;
  final Color borderMuted;

  // Alert Colors
  final Color error;
  final Color warning;
  final Color success;

  const AppColorToken({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.backgroundDark,
    required this.background,
    required this.backgroundLight,
    required this.text,
    required this.textMuted,
    required this.highlight,
    required this.border,
    required this.borderMuted,
    required this.error,
    required this.warning,
    required this.success,
  });

  @override
  ThemeExtension<AppColorToken> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? backgroundDark,
    Color? background,
    Color? backgroundLight,
    Color? text,
    Color? textMuted,
    Color? highlight,
    Color? border,
    Color? borderMuted,
    Color? error,
    Color? warning,
    Color? success,
  }) {
    return AppColorToken(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      background: background ?? this.background,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      highlight: highlight ?? this.highlight,
      border: border ?? this.border,
      borderMuted: borderMuted ?? this.borderMuted,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      success: success ?? this.success,
    );
  }

  @override
  ThemeExtension<AppColorToken> lerp(
    ThemeExtension<AppColorToken>? other,
    double t,
  ) {
    if (other is! AppColorToken) return this;
    return AppColorToken(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderMuted: Color.lerp(borderMuted, other.borderMuted, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(text, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

class AppRadiusToken extends ThemeExtension<AppRadiusToken> {
  final double extraSmall;
  final double small;
  final double medium;
  final double large;
  final double extraLarge;

  const AppRadiusToken({
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
  });

  @override
  ThemeExtension<AppRadiusToken> copyWith({
    double? extraSmall,
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    return AppRadiusToken(
      extraSmall: extraSmall ?? this.extraSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
    );
  }

  @override
  ThemeExtension<AppRadiusToken> lerp(
    ThemeExtension<AppRadiusToken>? other,
    double t,
  ) {
    if (other is! AppRadiusToken) return this;
    return AppRadiusToken(
      extraSmall: lerpDouble(extraSmall, other.extraSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      extraLarge: lerpDouble(extraLarge, other.extraLarge, t)!,
    );
  }
}

class AppSpaceToken extends ThemeExtension<AppSpaceToken> {
  final double extraSmall;
  final double small;
  final double medium;
  final double large;
  final double extraLarge;

  const AppSpaceToken({
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
  });

  @override
  ThemeExtension<AppSpaceToken> copyWith({
    double? extraSmall,
    double? small,
    double? medium,
    double? large,
    double? extraLarge,
  }) {
    return AppSpaceToken(
      extraSmall: extraSmall ?? this.extraSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
    );
  }

  @override
  ThemeExtension<AppSpaceToken> lerp(
    ThemeExtension<AppSpaceToken>? other,
    double t,
  ) {
    if (other is! AppSpaceToken) return this;
    return AppSpaceToken(
      extraSmall: lerpDouble(extraSmall, other.extraSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      extraLarge: lerpDouble(extraLarge, other.extraLarge, t)!,
    );
  }
}
