import 'package:hive_ce/hive_ce.dart';
import '../models/dish.dart';
import '../models/favorite_dish.dart';

class FavoritesService {
  static const String _boxName = 'favoritesBox';

  // Singleton pattern
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  Box<FavoriteDish>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<FavoriteDish>(_boxName);
  }

  Box<FavoriteDish> get box {
    if (_box == null) {
      throw StateError('FavoritesService not initialized. Call init() first.');
    }
    return _box!;
  }

  /// Toggles the favorite status of a dish.
  /// If adding, saves current date and mensa context.
  Future<void> toggleFavorite(Dish dish, Mensa mensa) async {
    final existingFav = getFavorite(dish);

    if (existingFav != null) {
      await existingFav.delete();
      dish.isFavorite = false;
    } else {
      final newFav = FavoriteDish(
        dishId: dish.id,
        name: dish.name,
        imageUrl: dish.imageUrl,
        category: dish.category,
        studentPrice: dish.studentPrice,
        mensaId: mensa.id,
        mensaName: mensa.displayName,
        favoritedDate: DateTime.now(),
        tags: dish.tags,
      );
      await box.put(_generateKey(dish), newFav);
      dish.isFavorite = true;
    }
  }

  String _generateKey(Dish dish) {
    return dish.name.trim().toLowerCase();
  }

  /// Checks if a dish is favorited.
  bool isFavorite(Dish dish) {
    return box.containsKey(_generateKey(dish));
  }

  /// Gets a specific favorite dish by its ID.
  FavoriteDish? getFavorite(Dish dish) {
    return box.get(_generateKey(dish));
  }

  /// Retrieves all favorites, optionally filtered by mensa ID.
  List<FavoriteDish> getFavorites({String? mensaId}) {
    final allFavs = box.values.toList();

    // Sort by favoritedDate descending (newest first)
    allFavs.sort((a, b) => b.favoritedDate.compareTo(a.favoritedDate));

    if (mensaId == null || mensaId == 'all') {
      return allFavs;
    }
    return allFavs.where((f) => f.mensaId == mensaId).toList();
  }

  /// Returns a stream of box events (for reactive UI updates).
  Stream<BoxEvent> watchFavorites() {
    return box.watch();
  }
}
