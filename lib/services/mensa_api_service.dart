import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dish.dart';

class MensaApiService {
  static const String _baseUrl = 'https://stwpb.de/wp-json/stwk-pb/v1/meals';

  /// Fetches meals for a given venue and date range.
  /// [venue] is one of: 'mensa', 'mensa-forum', 'mensa-zm2'
  /// [startDate] and [endDate] are in 'yyyy-MM-dd' format
  static Future<List<Dish>> fetchMeals({
    required String venue,
    required String startDate,
    required String endDate,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'venue': venue,
        'start_date': startDate,
        'end_date': endDate,
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final meals = data['meals'] as List? ?? [];
        return meals
            .map((m) => Dish.fromJson(m as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Fetches meals for a single day and groups them by display category.
  static Future<Map<String, List<Dish>>> fetchMealsGrouped({
    required String venue,
    required String date,
  }) async {
    final meals = await fetchMeals(
      venue: venue,
      startDate: date,
      endDate: date,
    );

    final grouped = <String, List<Dish>>{};
    for (final dish in meals) {
      final cat = dish.displayCategory;
      grouped.putIfAbsent(cat, () => []);
      grouped[cat]!.add(dish);
    }
    return grouped;
  }

  /// Fetches a full week of meals (Mon-Fri) for a venue.
  /// Returns a map of date -> list of dishes.
  static Future<Map<String, List<Dish>>> fetchWeek({
    required String venue,
    required DateTime weekStart,
  }) async {
    final startDate = formatDate(weekStart);
    final endDate = formatDate(
      weekStart.add(const Duration(days: 4)),
    ); // Mon-Fri

    final meals = await fetchMeals(
      venue: venue,
      startDate: startDate,
      endDate: endDate,
    );

    final byDate = <String, List<Dish>>{};
    for (final dish in meals) {
      byDate.putIfAbsent(dish.date, () => []);
      byDate[dish.date]!.add(dish);
    }
    return byDate;
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
