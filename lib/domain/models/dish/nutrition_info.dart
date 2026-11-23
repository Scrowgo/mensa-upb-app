class NutritionInfo {
  final double? energyKcal;
  final double? fatGrams;
  final double? saturatedFatGrams;
  final double? carbsGrams;
  final double? sugarGrams;
  final double? proteinGrams;
  final double? saltGrams;

  const NutritionInfo({
    this.energyKcal,
    this.fatGrams,
    this.saturatedFatGrams,
    this.carbsGrams,
    this.sugarGrams,
    this.proteinGrams,
    this.saltGrams,
  });

  static final _kcalRegex = RegExp(r'\((\d+(?:,\d+)?)\s*kcal\)');
  static final _fatRegex = RegExp(r'Fett=([\d,]+)\s*g');
  static final _satFatRegex = RegExp(
    r'davon gesättigte Fettsäuren=([\d,]+)\s*g',
  );
  static final _carbsRegex = RegExp(r'Kohlenhydrate=([\d,]+)\s*g');
  static final _sugarRegex = RegExp(r'davon Zucker=([\d,]+)\s*g');
  static final _proteinRegex = RegExp(r'Eiweiß=([\d,]+)\s*g');
  static final _saltRegex = RegExp(r'Salz=([\d,]+)\s*g');

  static double? _parseMatch(String input, RegExp pattern) {
    final match = pattern.firstMatch(input)?.group(1);
    if (match == null) return null;
    return double.tryParse(match.replaceAll(',', '.'));
  }

  /// Parses API strings like:
  /// "Brennwert=1904 kJ (455 kcal), Fett=24,0g, davon gesättigte Fettsäuren=2,1g, ..."
  factory NutritionInfo.fromApiString(String raw) {
    if (raw.isEmpty || raw.trim() == '-') {
      return const NutritionInfo();
    }
    return NutritionInfo(
      energyKcal: _parseMatch(raw, _kcalRegex),
      fatGrams: _parseMatch(raw, _fatRegex),
      saturatedFatGrams: _parseMatch(raw, _satFatRegex),
      carbsGrams: _parseMatch(raw, _carbsRegex),
      sugarGrams: _parseMatch(raw, _sugarRegex),
      proteinGrams: _parseMatch(raw, _proteinRegex),
      saltGrams: _parseMatch(raw, _saltRegex),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionInfo &&
          runtimeType == other.runtimeType &&
          energyKcal == other.energyKcal &&
          fatGrams == other.fatGrams &&
          saturatedFatGrams == other.saturatedFatGrams &&
          carbsGrams == other.carbsGrams &&
          sugarGrams == other.sugarGrams &&
          proteinGrams == other.proteinGrams &&
          saltGrams == other.saltGrams;

  @override
  int get hashCode => Object.hash(
        energyKcal,
        fatGrams,
        saturatedFatGrams,
        carbsGrams,
        sugarGrams,
        proteinGrams,
        saltGrams,
      );
}
