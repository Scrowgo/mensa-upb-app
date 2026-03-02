import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/dish.dart';
import '../theme/app_theme.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback onDetailsTap;
  final VoidCallback? onFavoriteTap;

  const DishCard({
    super.key,
    required this.dish,
    required this.onDetailsTap,
    this.onFavoriteTap,
  });

  Color _getTagTextColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'vegan':
        return AppTheme.backgroundDark;
      case 'regional':
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Color _getTagBgColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'vegan':
        return AppTheme.primary;
      case 'regional':
        return Colors.red.shade600;
      default:
        return AppTheme.backgroundDark.withValues(alpha: 0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A08).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: dish.imageUrl,
                height: 192,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 192,
                  color: const Color(0xFF1A2A10),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 192,
                  color: const Color(0xFF1A2A10),
                  child: const Icon(
                    Icons.restaurant,
                    color: AppTheme.primary,
                    size: 48,
                  ),
                ),
              ),
              // Tags
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: dish.tags.map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _getTagBgColor(tag),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          tag.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _getTagTextColor(tag),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Favorite button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDark.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      dish.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: dish.isFavorite ? AppTheme.primary : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        dish.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${dish.studentPrice.toStringAsFixed(2).replaceAll('.', ',')} €',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  dish.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Studierende Preis',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    GestureDetector(
                      onTap: onDetailsTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.backgroundDark,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppTheme.backgroundDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
