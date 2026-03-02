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

    // Exact same ordering logic as the Dish model to ensure consistency
    if (cat.contains('dessert')) {
      return 'dessert';
    }
    if (cat.contains('beilagensalat') ||
        cat.contains('gemüsebeil') ||
        cat.contains('sättigungbeil')) {
      return 'beilage';
    }
    if (cat.contains('zwischenverpflegung')) {
      return 'snack';
    }
    if (cat.contains('vegan') ||
        cat.contains('vegetarisch') ||
        cat.contains('fleisch') ||
        cat.contains('fisch') ||
        cat.contains('aktionsessen') ||
        cat.contains('eintopf') ||
        cat.contains('cafeteria')) {
      return 'hauptgericht';
    }
    return 'hauptgericht';
  }
}
