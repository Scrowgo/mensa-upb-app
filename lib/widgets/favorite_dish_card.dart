import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/favorite_dish.dart';
import '../theme/app_theme.dart';

class FavoriteDishCard extends StatelessWidget {
  final FavoriteDish dish;
  final VoidCallback onUnfavorite;
  final bool isAvailableToday;
  final String? availableTodayMensa;

  const FavoriteDishCard({
    super.key,
    required this.dish,
    required this.onUnfavorite,
    required this.isAvailableToday,
    this.availableTodayMensa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Same dark slate as normal cards
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Phase
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (dish.imageUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: dish.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            _buildPlaceholder(),
                      )
                    else
                      _buildPlaceholder(),

                    // Gradient overlay for text readability
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Tags overlay (up to 2 tags to fit small card)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: dish.tags
                            .take(2)
                            .map((tag) => _buildTag(tag))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Phase
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dish.studentPrice.toStringAsFixed(2).replaceAll('.', ',')} €',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const Spacer(),

                      // Availability Indicator
                      _buildAvailabilityIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Unfavorite Button
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: AppTheme.primary,
                  size: 20,
                ),
                onPressed: onUnfavorite,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                splashRadius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[850],
      child: const Center(
        child: Icon(Icons.restaurant, color: Colors.grey, size: 30),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: AppTheme.primary,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAvailabilityIndicator() {
    if (isAvailableToday) {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.primary, size: 12),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Heute in $availableTodayMensa',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Not available today
    final dateToken =
        '${dish.favoritedDate.day.toString().padLeft(2, '0')}.${dish.favoritedDate.month.toString().padLeft(2, '0')}.${dish.favoritedDate.year}';

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.history, color: AppTheme.textTertiary, size: 12),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Gesehen in ${dish.mensaName}\nam $dateToken',
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
