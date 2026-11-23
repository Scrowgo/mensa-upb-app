import 'package:mensa_app/core/enums.dart';
import 'package:mensa_app/domain/models.dart';

abstract class DishRepository {
  /// Fetches the mensa API and updates the internal database.
  ///
  /// The mensa API is only fetched...
  /// 1. when the app starts and the cache is empty/outdated.
  /// 2. from a pull to refresh trigger.
  ///
  /// All dishes are saved to a local HiveBox. If [mensas] is empty,
  /// all mensas are updates, otherwise only the mensas specified in the list.
  ///
  /// Clears dishes out of the HiveBox, if they are older than 7 days.
  ///
  /// Returns all fetched Dishes.
  Future<List<Dish>> updateDishes({
    List<Mensa> mensas = const [],
    bool forceRefresh = false,
  });

  /// Query the local Hive database for dishes.
  ///
  /// The query includes [startDate] and [endDate].
  Future<List<Dish>> getDishes({
    List<Mensa>? mensa,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Return all favorited dishes.
  ///
  /// Favorited dishes are stored in their own unique local HiveBox.
  Future<List<FavoriteDish>> getFavorites();

  /// Toggle a dishes favorite status.
  Future<void> toggleFavorite({required Dish dish});
}
