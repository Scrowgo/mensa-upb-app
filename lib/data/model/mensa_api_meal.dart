import 'mensa_api_allergens_decoded.dart';

/// Raw meal entry as returned by the external REST API.
class MensaApiMeal {
  /// Unique numeric identifier assigned by the backend database.
  final int id;

  /// Display title of the dish (typically in German).
  final String title;

  /// Serving date in ISO-8601 `YYYY-MM-DD` format.
  final String date;

  /// Localized serving date formatted for German display (e.g., `'27.11.2026'`).
  final String dateGerman;

  /// Menu line or counter category (e.g., `'Hauptgericht'`, `'Beilage'`).
  final String category;

  /// Identifier slug of the dining hall where this meal is served.
  final String venue;

  /// Human-readable name of the dining hall where this meal is served.
  final String venueName;

  /// Formatted price string for students (e.g., `'2,90 €'`).
  final String priceStudents;

  /// Formatted price string for university staff.
  final String priceStaff;

  /// Formatted price string for external guests.
  final String priceGuests;

  /// Comma-separated raw allergen and additive codes (e.g., `'A1,G,2'`).
  final String allergensRaw;

  /// Structured breakdown of allergens and additives, or `null` if none apply
  /// or if the backend omits the object.
  final MensaApiAllergensDecoded? allergensDecoded;

  /// Unstructured or HTML-formatted nutritional information string, if provided.
  final String nutrition;

  /// Label or metadata for an optional action button provided by the CMS.
  final String button;

  /// Full-resolution JPEG image URL, or an empty string if unavailable.
  final String imageJpeg;

  /// Full-resolution WebP image URL, or an empty string if unavailable.
  final String imageWebp;

  /// Medium/small JPEG image URL, or an empty string if unavailable.
  final String imageJpegSmall;

  /// Medium/small WebP image URL, or an empty string if unavailable.
  final String imageWebpSmall;

  /// Thumbnail JPEG image URL, or an empty string if unavailable.
  final String imageJpegThumb;

  /// Thumbnail WebP image URL, or an empty string if unavailable.
  final String imageWebpThumb;

  const MensaApiMeal({
    required this.id,
    required this.title,
    required this.date,
    required this.dateGerman,
    required this.category,
    required this.venue,
    required this.venueName,
    required this.priceStudents,
    required this.priceStaff,
    required this.priceGuests,
    required this.allergensRaw,
    this.allergensDecoded,
    required this.nutrition,
    required this.button,
    required this.imageJpeg,
    required this.imageWebp,
    required this.imageJpegSmall,
    required this.imageWebpSmall,
    required this.imageJpegThumb,
    required this.imageWebpThumb,
  });
}
