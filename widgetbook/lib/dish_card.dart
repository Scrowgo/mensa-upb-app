import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:mensa_app/ui/core/ui/dish_card.dart';
import 'package:mensa_app/core/enums.dart';
import 'package:mensa_app/domain/models.dart';

@widgetbook.UseCase(name: 'Default', type: DishCard)
Widget buildDishCardUseCase(BuildContext context) {
  return DishCard(
    dish: Dish(
      name: context.knobs.string(label: 'Dish Name'),
      date: DateTime(2026, 16, 12),
      mensa: Mensa.academica,
      studentPrice: 3.10,
      staffPrice: 4.80,
      guestPrice: 6.30,
      tags: [DishTag.vegan, DishTag.vegetarian, DishTag.meat],
    ),
    onDetailsTap: () {},
    onFavoriteTap: () {},
  );
}

@widgetbook.UseCase(name: 'Default', type: FavoriteButton)
Widget buildFavoriteButtonUseCase(BuildContext context) {
  return FavoriteButton(
    onTap: () {},
    isFavorite: context.knobs.boolean(label: 'isFavorite'),
  );
}

@widgetbook.UseCase(name: 'Default', type: DetailsButton)
Widget buildDetailsButtonUseCase(BuildContext context) {
  return DetailsButton(onTap: () {});
}
