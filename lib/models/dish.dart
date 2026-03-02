class Dish {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double studentPrice;
  final double staffPrice;
  final double guestPrice;
  final List<String> tags;
  final double rating;
  final String energy;
  final String fat;
  final String carbs;
  final String protein;
  final String ingredients;
  final List<String> allergens;
  final String category;
  final String date;
  bool isFavorite;

  Dish({
    this.id = 0,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    required this.studentPrice,
    this.staffPrice = 0,
    this.guestPrice = 0,
    this.tags = const [],
    this.rating = 0,
    this.energy = '',
    this.fat = '',
    this.carbs = '',
    this.protein = '',
    this.ingredients = '',
    this.allergens = const [],
    this.category = '',
    this.date = '',
    this.isFavorite = false,
  });

  /// Determines the display category from the API "category" field.
  /// Returns 'hauptgericht', 'beilage', 'dessert', or 'snack'.
  ///
  /// Check specific categories (dessert, beilage, snack) BEFORE
  /// broad ones (vegan, vegetarisch) so "Counter Dessert Vegan"
  /// is correctly classified as dessert, not hauptgericht.
  String get displayCategory {
    final cat = category.toLowerCase();
    // Specific categories first
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
    // Broad main-dish categories last
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

  factory Dish.fromJson(Map<String, dynamic> json) {
    // Parse prices (German format "3,40" to double)
    double parsePrice(String? price) {
      if (price == null || price.isEmpty) return 0.0;
      return double.tryParse(price.replaceAll(',', '.')) ?? 0.0;
    }

    // Parse nutrition string like "Brennwert=798 kJ (191 kcal), Fett=8,1g, Kohlenhydrate=26,5g, Eiweiß=1,1g,"
    String energy = '';
    String fat = '';
    String carbs = '';
    String protein = '';
    final nutritionStr = json['nutrition'] as String? ?? '';
    if (nutritionStr.isNotEmpty) {
      final kcalMatch = RegExp(r'\((\d+ kcal)\)').firstMatch(nutritionStr);
      energy = kcalMatch?.group(1) ?? '';

      final fatMatch = RegExp(r'Fett=([\d,]+g)').firstMatch(nutritionStr);
      fat = fatMatch?.group(1)?.replaceAll(',', '.') ?? '';

      final carbMatch = RegExp(
        r'Kohlenhydrate=([\d,]+g)',
      ).firstMatch(nutritionStr);
      carbs = carbMatch?.group(1)?.replaceAll(',', '.') ?? '';

      final proteinMatch = RegExp(r'Eiweiß=([\d,]+g)').firstMatch(nutritionStr);
      protein = proteinMatch?.group(1)?.replaceAll(',', '.') ?? '';
    }

    // Extract tags from category
    final categoryStr = json['category'] as String? ?? '';
    List<String> tags = [];
    final catLower = categoryStr.toLowerCase();
    if (catLower.contains('vegan')) tags.add('Vegan');
    if (catLower.contains('vegetarisch')) tags.add('Vegetarisch');
    if (catLower.contains('fleisch') || catLower.contains('fisch')) {
      // Check allergens for meat type
      final allergensDecoded = json['allergens_decoded'];
      if (allergensDecoded != null && allergensDecoded is Map) {
        final allergensList = allergensDecoded['allergens'] as List? ?? [];
        for (final a in allergensList) {
          if (a['category'] == 'meat') {
            tags.add(a['name_de'] as String);
          }
        }
        if (allergensList.any(
          (a) => (a['name_en'] as String? ?? '').toLowerCase() == 'fish',
        )) {
          tags.add('Fisch');
        }
      }
      if (tags.isEmpty) tags.add('Fleisch/Fisch');
    }
    if (catLower.contains('aktionsessen')) tags.add('Aktion');

    // Extract allergens
    List<String> allergens = [];
    final allergensDecoded = json['allergens_decoded'];
    if (allergensDecoded != null && allergensDecoded is Map) {
      final allergensList = allergensDecoded['allergens'] as List? ?? [];
      for (final a in allergensList) {
        final cat = a['category'] as String? ?? '';
        if (cat == 'allergen') {
          allergens.add(a['name_de'] as String);
        }
      }
    }

    return Dish(
      id: json['id'] as int? ?? 0,
      name: _decodeHtmlEntities(json['title'] as String? ?? ''),
      imageUrl: json['image_jpeg'] as String? ?? '',
      studentPrice: parsePrice(json['price_students'] as String?),
      staffPrice: parsePrice(json['price_staff'] as String?),
      guestPrice: parsePrice(json['price_guests'] as String?),
      tags: tags,
      energy: energy,
      fat: fat,
      carbs: carbs,
      protein: protein,
      allergens: allergens,
      category: categoryStr,
      date: json['date'] as String? ?? '',
    );
  }
}

class Mensa {
  final String id; // API venue name: 'mensa', 'mensa-forum', 'mensa-zm2'
  final String displayName;

  const Mensa({required this.id, required this.displayName});

  static const List<Mensa> all = [
    Mensa(id: 'mensa', displayName: 'Mensa Academica'),
    Mensa(id: 'mensa-forum', displayName: 'Mensa Forum'),
    Mensa(id: 'mensa-zm2', displayName: 'Mensa ZM2'),
  ];
}
