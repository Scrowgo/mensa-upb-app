import 'package:mensa_app/core/enums.dart';
import 'package:mensa_app/data/services/services.dart';
import 'package:mensa_app/domain/models.dart';
import 'package:uuid/uuid.dart';

import 'dish_repository.dart';

class DishRepositoryRemote implements DishRepository {
  final HiveService _hiveService;
  final MensaApiService _mensaApiService;

  DishRepositoryRemote({
    required this._hiveService,
    required this._mensaApiService,
  });

  final Uuid _uuid = Uuid();
  final String _dishBox = HiveBoxNames.dishes.name;
  final String _favoritesBox = HiveBoxNames.favorites.name;

  @override
  Future<List<Dish>> updateDishes({required List<Mensa> mensas}) async {
    // Get monday of the current week and compute next week friday.
    // Format them to yyyy-MM-dd to fit for MensaApiCall.
    DateTime now = DateTime.now();
    DateTime weekStart = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );
    String startDate = _mensaApiService.formatDate(weekStart);
    String endDate = _mensaApiService.formatDate(
      weekStart.add(const Duration(days: 7 + 4)),
    );

    List<Dish> newMeals = [];
    for (Mensa venue in mensas) {
      List<Dish> meals = await _mensaApiService.fetchMeals(
        venue: venue.id,
        startDate: startDate,
        endDate: endDate,
      );
      newMeals.addAll(meals);
    }

    for (Dish dish in newMeals) {
      await _hiveService.saveToBox(
        _dishBox,
        key: _generateKey(dish),
        value: dish,
      );
    }

    return newMeals;
  }

  @override
  Future<List<Dish>> getDishes({
    List<Mensa>? mensa,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dishes = await _hiveService.getAllFromBox<String, Dish>(_dishBox);

    if (mensa == null && startDate == null && endDate == null) {
      return dishes;
    }

    final startStr = startDate != null
        ? _mensaApiService.formatDate(startDate)
        : null;
    final endStr = endDate != null
        ? _mensaApiService.formatDate(endDate)
        : null;

    return dishes.where((dish) {
      if (mensa != null && !mensa.contains(dish.mensa)) {
        return false;
      }

      if (startStr != null && dish.date.compareTo(startStr) < 0) {
        return false;
      }

      if (endStr != null && dish.date.compareTo(endStr) > 0) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Future<List<Dish>> getFavorites() async {
    List<Dish> favorites = await _hiveService.getAllFromBox<String, Dish>(
      _favoritesBox,
    );
    return favorites;
  }

  @override
  Future<void> toggleFavorite({required Dish dish}) async {
    bool isFavorite = await _hiveService.boxContains<String, Dish>(
      _favoritesBox,
      key: dish.uuid,
    );

    if (isFavorite) {
      await _hiveService.deleteFromBox(_favoritesBox, key: dish.uuid);
    } else {
      await _hiveService.saveToBox(_favoritesBox, key: dish.uuid, value: dish);
    }
  }
}
