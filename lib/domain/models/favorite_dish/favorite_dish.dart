import 'package:hive_ce/hive_ce.dart';

class FavoriteDish extends HiveObject {
  final int dishId;
  final String name;
  final String imageUrl;
  final String category;
  final double studentPrice;

  final String mensaId;
  final String mensaName;
  final DateTime favoritedDate;
  final List<String> tags;

  FavoriteDish({
    required this.dishId,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.studentPrice,
    required this.mensaId,
    required this.mensaName,
    required this.favoritedDate,
    required this.tags,
  });

  String get displayCategory {
    final cat = category.toLowerCase();

    // Exact same ordering logic as the Dish model to ensure consistency:
    // 1. Suppen & Eintöpfe — check before Hauptgerichte
    if (cat.contains('eintopf') || cat.contains('suppe')) {
      return 'suppe';
    }
    // 2. Beilagen
    if (cat.contains('beilage') ||
        cat.contains('gemüsebeil') ||
        cat.contains('sättigungbeil')) {
      return 'beilage';
    }
    // 3. Desserts
    if (cat.contains('dessert')) {
      return 'dessert';
    }
    // 4. Hauptgerichte
    return 'hauptgericht';
  }

  int get categoryPriority {
    switch (displayCategory) {
      case 'hauptgericht':
        return 1;
      case 'suppe':
        return 2;
      case 'beilage':
        return 3;
      case 'dessert':
        return 4;
      default:
        return 5;
    }
  }

  String get displayCategoryName {
    switch (displayCategory) {
      case 'hauptgericht':
        return 'Hauptgerichte';
      case 'suppe':
        return 'Suppen & Eintöpfe';
      case 'beilage':
        return 'Beilagen';
      case 'dessert':
        return 'Desserts';
      default:
        return 'Hauptgerichte';
    }
  }
}
