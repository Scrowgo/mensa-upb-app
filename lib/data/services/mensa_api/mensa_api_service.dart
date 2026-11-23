import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/mensa_api_response.dart';

class MensaApiService {
  static const String _baseUrl = 'https://stwpb.de/wp-json/stwk-pb/v1/meals';

  /// Fetches the raw meal response for a given venue and date range.
  ///
  /// [venue] is the venue slug, e.g. `'mensa'`, `'mensa-forum'`, `'mensa-zm2'`.
  /// [startDate] and [endDate] must be formatted as `'YYYY-MM-DD'`.
  Future<MensaApiResponse?> fetchMeals({
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
        return MensaApiResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
