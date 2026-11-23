import 'package:mensa_app/core/enums.dart';
import 'package:mensa_app/data/services/services.dart';
import 'package:mensa_app/domain/models.dart';

import '../../model/mensa_api_meal.dart';
import '../../model/mensa_api_response.dart';
import 'dish_repository.dart';

class DishRepositoryRemote implements DishRepository {
  final HiveService _hiveService;
  final MensaApiService _mensaApiService;

  DishRepositoryRemote({
    required this._hiveService,
    required this._mensaApiService,
  });

  final String _dishBox = HiveBoxNames.dishes.name;
  final String _favoritesBox = HiveBoxNames.favorites.name;
  DateTime? lastFetchedAt;

  @override
  Future<List<Dish>> updateDishes({
    List<Mensa> mensas = const [],
    bool forceRefresh = false,
  }) async {
    DateTime now = DateTime.now();
    bool shouldFetch =
        now.difference(lastFetchedAt ?? DateTime(1)) >= Duration(hours: 1);

    // Return early when no fetching or refresh is needed
    if (!shouldFetch && !forceRefresh) {
      return getDishes(mensa: mensas.isEmpty ? null : mensas);
    }

    // Get monday of the current week and compute next week friday and
    // format them to YYYY-MM-DD to fit for MensaApiCall.
    DateTime currentWeekStart = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );
    DateTime nextWeekEnd = currentWeekStart.add(Duration(days: 11));
    String startDate = _mensaApiService.formatDate(currentWeekStart);
    String endDate = _mensaApiService.formatDate(nextWeekEnd);

    // Fetch meals from mensa API
    if (mensas.isEmpty) mensas = Mensa.values;

    List<MensaApiMeal> fetchedMeals = [];
    for (Mensa mensa in mensas) {
      // TODO: parallelize fetching
      MensaApiResponse? response = await _mensaApiService.fetchMeals(
        venue: mensa.id,
        startDate: startDate,
        endDate: endDate,
      );
      fetchedMeals.addAll(response?.meals ?? []);
    }
    lastFetchedAt = now;

    // Save meals to local database
    List<Dish> fetchedDishes = [];
    for (MensaApiMeal meal in fetchedMeals) {
      Dish dish = Dish.fromMensaApiMeal(meal);
      fetchedDishes.add(dish);
      await _hiveService.saveToBox<String, Dish>(
        _dishBox,
        key: dish.uuid,
        value: dish,
      );
    }

    // Update lastSeen fields in favorite dishes.
    // Recognizes reoccuring dishes by their normalized dish name
    // e.g. dish.name.trim().toLower().
    List<FavoriteDish> favorites = await getFavorites();
    List<Dish> dishes = await getDishes();

    // Create a map between the normalized dish names and
    // the latest date for that dish.
    final latestPastDateByName = <String, DateTime>{};
    for (final dish in dishes) {
      if (dish.date.isAfter(now)) continue;
      final key = dish.name.trim().toLowerCase();
      final existing = latestPastDateByName[key];
      if (existing == null || dish.date.isAfter(existing)) {
        latestPastDateByName[key] = dish.date;
      }
    }
    for (final favorite in favorites) {
      final latest = latestPastDateByName[favorite.name.trim().toLowerCase()];
      if (latest != null && latest.isAfter(favorite.lastSeen)) {
        await _hiveService.saveToBox<String, FavoriteDish>(
          _favoritesBox,
          key: favorite.uuid,
          value: favorite.copyWith(lastSeen: latest),
        );
      }
    }

    // Remove dishes older than 7 days
    DateTime cutoff = now.subtract(Duration(days: 7));
    List<String> deleteKeys = dishes
        .where((dish) => dish.date.isBefore(cutoff))
        .map((e) => e.uuid)
        .toList();
    await _hiveService.deleteMultipleFromBox<String, Dish>(
      _dishBox,
      keys: deleteKeys,
    );

    return fetchedDishes;
  }

  @override
  Future<List<Dish>> getDishes({
    List<Mensa>? mensa,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dishes = await _hiveService.getAllFromBox<String, Dish>(_dishBox);

    final normalizedStart = startDate != null
        ? DateTime(startDate.year, startDate.month, startDate.day)
        : null;
    final normalizedEnd = endDate != null
        ? DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999)
        : null;

    if (mensa == null && normalizedStart == null && normalizedEnd == null) {
      return dishes;
    }

    return dishes.where((dish) {
      if (mensa != null && !mensa.contains(dish.mensa)) {
        return false;
      }

      if (normalizedStart != null && dish.date.isBefore(normalizedStart)) {
        return false;
      }

      if (normalizedEnd != null && dish.date.isAfter(normalizedEnd)) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Future<List<FavoriteDish>> getFavorites() async {
    List<FavoriteDish> favorites = await _hiveService
        .getAllFromBox<String, FavoriteDish>(_favoritesBox);
    return favorites;
  }

  @override
  Future<void> toggleFavorite({required Dish dish}) async {
    bool isFavorite = await _hiveService.boxContains<String, FavoriteDish>(
      _favoritesBox,
      key: dish.uuid,
    );

    if (isFavorite) {
      await _hiveService.deleteFromBox<String, FavoriteDish>(
        _favoritesBox,
        key: dish.uuid,
      );
    } else {
      await _hiveService.saveToBox<String, FavoriteDish>(
        _favoritesBox,
        key: dish.uuid,
        value: FavoriteDish.fromDish(
          dish,
          favoritedDate: DateTime.now(),
          lastSeen: dish.date,
        ),
      );
    }
  }
}
