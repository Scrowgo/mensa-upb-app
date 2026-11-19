import 'mensa_api_meal.dart';

/// Top-level payload returned by the Studierendenwerk Paderborn meals endpoint.
class MensaApiResponse {
  /// Identifier slug of the requested dining hall (e.g., `'mensa'`).
  final String venue;

  /// Human-readable display name of the dining hall.
  final String venueName;

  /// Inclusive start date of the queried range in `YYYY-MM-DD` format.
  final String startDate;

  /// Inclusive end date of the queried range in `YYYY-MM-DD` format.
  final String endDate;

  /// List of meals served within the requested date range and venue.
  final List<MensaApiMeal> meals;

  /// Total number of meals within the requested date range and venue.
  final int total;

  const MensaApiResponse({
    required this.venue,
    required this.venueName,
    required this.startDate,
    required this.endDate,
    required this.meals,
    required this.total,
  });

  factory MensaApiResponse.fromJson(Map<String, dynamic> json) {
    final rawMeals = json['meals'] as List<dynamic>? ?? [];
    final parsedMeals = rawMeals.map((e) => MensaApiMeal.fromJson(e)).toList();

    return MensaApiResponse(
      venue: json['venue']?.toString() ?? '',
      venueName: json['venue_name']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      meals: parsedMeals,
      total: (json['total'] as num?)?.toInt() ?? parsedMeals.length,
    );
  }
}
