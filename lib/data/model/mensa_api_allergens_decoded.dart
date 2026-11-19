/// Decoded allergen and additive metadata attached to a [MensaApiMeal].
class MensaApiAllergensDecoded {
  /// Resolved allergen entries matched from [rawCodes].
  final List<MensaApiAllergen> allergens;

  /// Resolved food additive entries matched from [rawCodes].
  final List<MensaApiAdditive> additives;

  /// Unfiltered list of shorthand codes extracted from the meal record.
  final List<String> rawCodes;

  const MensaApiAllergensDecoded({
    required this.allergens,
    required this.additives,
    required this.rawCodes,
  });

  factory MensaApiAllergensDecoded.fromJson(Map<String, dynamic> json) {
    final rawAllergens = json['allergens'] as List<dynamic>? ?? [];
    final rawAdditives = json['additives'] as List<dynamic>? ?? [];
    final rawCodes = json['raw_codes'] as List<dynamic>? ?? [];

    return MensaApiAllergensDecoded(
      allergens: rawAllergens.map((e) => MensaApiAllergen.fromJson(e)).toList(),
      additives: rawAdditives.map((e) => MensaApiAdditive.fromJson(e)).toList(),
      rawCodes: rawCodes.map((e) => e.toString()).toList(),
    );
  }
}

/// Detailed metadata for a single statutory allergen.
class MensaApiAllergen {
  /// Backend record identifier (serialized as a string by the API).
  final String id;

  /// Official shorthand code used in menus (e.g., `'A1'`, `'G'`).
  final String code;

  /// German display name of the allergen.
  final String nameDe;

  /// English display name of the allergen.
  final String nameEn;

  /// Grouping classification (typically `'allergen'`).
  final String category;

  /// Backend status flag indicating whether this entry is enabled (e.g., `'1'`).
  final String active;

  /// Numeric display priority serialized as a string by the API.
  final String sortOrder;

  const MensaApiAllergen({
    required this.id,
    required this.code,
    required this.nameDe,
    required this.nameEn,
    required this.category,
    required this.active,
    required this.sortOrder,
  });

  factory MensaApiAllergen.fromJson(Map<String, dynamic> json) {
    return MensaApiAllergen(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      nameDe: json['name_de']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      active: json['active']?.toString() ?? '',
      sortOrder: json['sort_order']?.toString() ?? '',
    );
  }
}

/// Detailed metadata for a single declarable food additive.
class MensaApiAdditive {
  /// Backend record identifier (serialized as a string by the API).
  final String id;

  /// Official shorthand code used in menus (e.g., `'1'`, `'2'`).
  final String code;

  /// German display name of the additive.
  final String nameDe;

  /// English display name of the additive.
  final String nameEn;

  /// Backend status flag indicating whether this entry is enabled (e.g., `'1'`).
  final String active;

  /// Numeric display priority serialized as a string by the API.
  final String sortOrder;

  const MensaApiAdditive({
    required this.id,
    required this.code,
    required this.nameDe,
    required this.nameEn,
    required this.active,
    required this.sortOrder,
  });

  factory MensaApiAdditive.fromJson(Map<String, dynamic> json) {
    return MensaApiAdditive(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      nameDe: json['name_de']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      active: json['active']?.toString() ?? '',
      sortOrder: json['sort_order']?.toString() ?? '',
    );
  }
}
