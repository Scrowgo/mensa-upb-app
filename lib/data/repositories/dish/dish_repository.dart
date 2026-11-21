import 'package:mensa_app/domain/models.dart';

abstract class DishRepository {
  Future<List<Dish>> updateDishes({required List<Mensa> mensas});

  Future<List<Dish>> getDishes({
    List<Mensa>? mensa,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<Dish>> getFavorites();

  Future<void> toggleFavorite({required Dish dish});
}
