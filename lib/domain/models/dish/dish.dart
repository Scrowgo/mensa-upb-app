import 'package:flutter/foundation.dart';
import 'package:mensa_app/core/enums.dart';
import 'package:uuid/uuid.dart';

import '../../../data/model/mensa_api_meal.dart';
import 'nutrition_info.dart';

class Dish {
  final String uuid;
  final String name;
  final String imageUrl;
  final DateTime date;
  final Mensa mensa;
  final double studentPrice;
  final double staffPrice;
  final double guestPrice;
  final List<DishTag> tags;
  final DishCategory category;
  final NutritionInfo nutritionInfo;
  final List<Allergen> allergens;
  final List<Additive> additives;
  final bool isFavorite;

  Dish({
    String? uuid,
    required this.name,
    this.imageUrl = '',
    required this.date,
    required this.mensa,
    required this.studentPrice,
    required this.staffPrice,
    required this.guestPrice,
    this.tags = const [],
    this.category = DishCategory.other,
    this.nutritionInfo = const NutritionInfo(),
    this.allergens = const [],
    this.additives = const [],
    this.isFavorite = false,
  }) : uuid = uuid ?? _generateUuid(mensa, date, name);

  static const _uuid = Uuid();

  static String _generateUuid(Mensa mensa, DateTime date, String name) {
    final dateKey = '${date.year}-${date.month}-${date.day}';
    final input = '${mensa.id}|$dateKey|${name.trim().toLowerCase()}';
    return _uuid.v5(Namespace.url.value, input);
  }

  /// Decodes HTML entities commonly found in API responses.
  static String _decodeHtmlEntities(String input) {
    return input
        .replaceAll('&#8222;', '„')
        .replaceAll('&#8220;', '“')
        .replaceAll('&#8221;', '”')
        .replaceAll('&#8216;', '‘')
        .replaceAll('&#8217;', '’')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'");
  }

  static double _parsePrice(String? price) {
    if (price == null || price.isEmpty) return 0.0;
    return double.tryParse(price.replaceAll(',', '.')) ?? 0.0;
  }

  factory Dish.fromMensaApiMeal(MensaApiMeal meal) {
    // Convert 'YYYY-MM-DD' to DateTime
    final date = DateTime.tryParse(meal.date) ?? DateTime.now();

    // Extract allergens
    final List<Allergen> allergens =
        meal.allergensDecoded?.allergens
            .map((a) => Allergen.fromId(a.id))
            .whereType<Allergen>()
            .toList() ??
        [];

    // Extract additives
    final List<Additive> additives =
        meal.allergensDecoded?.additives
            .map((a) => Additive.fromId(a.id))
            .whereType<Additive>()
            .toList() ??
        [];

    // Extract tags
    List<DishTag> tags = [];
    final category = meal.category.toLowerCase();
    if (category.contains('aktionsessen')) tags.add(DishTag.special);
    if (category.contains('vegan')) tags.add(DishTag.vegan);
    if (category.contains('vegetarisch')) tags.add(DishTag.vegetarian);
    if (category.contains('fleisch') || category.contains('fisch')) {
      // Check allergens for meat or fish type
      // Adds no tag if both or none allergens are found
      bool hasFish = false;
      bool hasMeat = false;
      for (var allergen in allergens) {
        if (allergen == Allergen.fish) hasFish = true;
        if (allergen == Allergen.pork || allergen == Allergen.beef) {
          hasMeat = true;
        }
      }
      if (!hasMeat && hasFish) tags.add(DishTag.fish);
      if (hasMeat && !hasFish) tags.add(DishTag.meat);
    }

    // DishCategory
    final dishCategory = switch (category) {
      _ when category.contains('eintopf') || category.contains('suppe') =>
        DishCategory.soup,
      _
          when category.contains('beilage') ||
              category.contains('gemüsebeil') ||
              category.contains('sättigungbeil') =>
        DishCategory.side,
      _ when category.contains('dessert') => DishCategory.dessert,
      _ => DishCategory.main,
    };

    return Dish(
      name: _decodeHtmlEntities(meal.title),
      imageUrl: meal.imageJpeg,
      date: date,
      mensa: Mensa.fromId(meal.venue) ?? Mensa.academica,
      studentPrice: _parsePrice(meal.priceStudents),
      staffPrice: _parsePrice(meal.priceStaff),
      guestPrice: _parsePrice(meal.priceGuests),
      tags: tags,
      category: dishCategory,
      nutritionInfo: NutritionInfo.fromApiString(meal.nutrition),
      allergens: allergens,
      additives: additives,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dish &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid &&
          name == other.name &&
          imageUrl == other.imageUrl &&
          date == other.date &&
          mensa == other.mensa &&
          studentPrice == other.studentPrice &&
          staffPrice == other.staffPrice &&
          guestPrice == other.guestPrice &&
          listEquals(tags, other.tags) &&
          category == other.category &&
          nutritionInfo == other.nutritionInfo &&
          listEquals(allergens, other.allergens) &&
          listEquals(additives, other.additives) &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hash(
        uuid,
        name,
        imageUrl,
        date,
        mensa,
        studentPrice,
        staffPrice,
        guestPrice,
        Object.hashAll(tags),
        category,
        nutritionInfo,
        Object.hashAll(allergens),
        Object.hashAll(additives),
        isFavorite,
      );
}
