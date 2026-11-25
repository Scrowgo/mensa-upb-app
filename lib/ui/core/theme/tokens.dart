import 'package:mix/mix.dart';

enum AppColorToken {
  // Brand Color Tokens
  primary('primary'),
  onPrimary('on-primary'),
  secondary('secondary'),

  // Background Color Tokens
  backgroundDark('background-dark'),
  background('background'),
  backgroundLight('background-light'),

  // Text Color Tokens
  text('text'),
  textMuted('text-muted'),

  // Border Color Tokens
  highlight('highlight'),
  border('border'),
  borderMuted('border-muted'),

  // Alert Color Tokens
  error('error'),
  warning('warning'),
  success('success');

  final String name;
  const AppColorToken(this.name);

  ColorToken get token => ColorToken(name);
}

enum AppTextStyleToken {
  appTitle('appTitle'),
  headline('headline'),

  button('button'),
  body('body');

  final String name;
  const AppTextStyleToken(this.name);

  TextStyleToken get token => TextStyleToken(name);
}

enum AppRadiusToken {
  medium('medium'),
  large('large');

  final String name;
  const AppRadiusToken(this.name);

  RadiusToken get token => RadiusToken(name);
}

enum AppSpaceToken {
  medium('medium'),
  large('large');

  final String name;
  const AppSpaceToken(this.name);

  SpaceToken get token => SpaceToken(name);
}
