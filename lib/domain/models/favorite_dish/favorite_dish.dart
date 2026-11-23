import 'package:mensa_app/core/enums.dart';

import '../dish/dish.dart';
import '../dish/nutrition_info.dart';

class FavoriteDish extends Dish {
  final DateTime favoritedDate;
  final DateTime lastSeen;

  FavoriteDish({
    super.uuid,
    required super.name,
    super.imageUrl = '',
    required super.date,
    required super.mensa,
    required super.studentPrice,
    required super.staffPrice,
    required super.guestPrice,
    super.tags = const [],
    super.category = DishCategory.other,
    super.nutritionInfo = const NutritionInfo(),
    super.allergens = const [],
    super.additives = const [],
    required this.favoritedDate,
    required this.lastSeen,
  }) : super(isFavorite: true);

  factory FavoriteDish.fromDish(
    Dish dish, {
    DateTime? favoritedDate,
    DateTime? lastSeen,
  }) {
    final now = DateTime.now();
    return FavoriteDish(
      uuid: dish.uuid,
      name: dish.name,
      imageUrl: dish.imageUrl,
      date: dish.date,
      mensa: dish.mensa,
      studentPrice: dish.studentPrice,
      staffPrice: dish.staffPrice,
      guestPrice: dish.guestPrice,
      tags: dish.tags,
      category: dish.category,
      nutritionInfo: dish.nutritionInfo,
      allergens: dish.allergens,
      additives: dish.additives,
      favoritedDate: favoritedDate ?? now,
      lastSeen: lastSeen ?? dish.date,
    );
  }

  FavoriteDish copyWith({
    DateTime? favoritedDate,
    DateTime? lastSeen,
  }) {
    return FavoriteDish(
      uuid: uuid,
      name: name,
      imageUrl: imageUrl,
      date: date,
      mensa: mensa,
      studentPrice: studentPrice,
      staffPrice: staffPrice,
      guestPrice: guestPrice,
      tags: tags,
      category: category,
      nutritionInfo: nutritionInfo,
      allergens: allergens,
      additives: additives,
      favoritedDate: favoritedDate ?? this.favoritedDate,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is FavoriteDish &&
          favoritedDate == other.favoritedDate &&
          lastSeen == other.lastSeen;

  @override
  int get hashCode => Object.hash(super.hashCode, favoritedDate, lastSeen);
}
