import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/dish.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import '../widgets/nutrition_card.dart';

class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  final Mensa mensa;

  const DishDetailScreen({super.key, required this.dish, required this.mensa});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  final FavoritesService _favoritesService = FavoritesService();

  Dish get dish => widget.dish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image
                _buildHeroImage(context),
                // Content overlapping image
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: _buildContent(context),
                ),
              ],
            ),
          ),
          // Top navigation overlay
          _buildTopNav(context),
          // Sticky CTA button
          _buildCTA(),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: CachedNetworkImage(
        imageUrl: widget.dish.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: const Color(0xFF1A2A10),
          child: const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF1A2A10),
          child: const Icon(
            Icons.restaurant,
            color: AppTheme.primary,
            size: 64,
          ),
        ),
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundDark.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    _buildCircleButton(icon: Icons.share),
                    const SizedBox(width: 8),
                    StreamBuilder(
                      stream: _favoritesService.watchFavorites(),
                      builder: (context, snapshot) {
                        final isFav = _favoritesService.isFavorite(widget.dish);
                        return _buildCircleButton(
                          icon: isFav ? Icons.favorite : Icons.favorite_border,
                          iconColor: isFav ? AppTheme.primary : Colors.white,
                          onTap: () async {
                            await _favoritesService.toggleFavorite(
                              widget.dish,
                              widget.mensa,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    VoidCallback? onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final dish = widget.dish;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  dish.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (dish.rating > 0)
                Row(
                  children: [
                    const Icon(Icons.star, color: AppTheme.primary, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      dish.rating.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Dietary badges
          if (dish.tags.isNotEmpty) ...[
            _buildDietaryBadges(),
            const SizedBox(height: 24),
          ],

          // Pricing table
          _buildPricingTable(),
          const SizedBox(height: 32),

          // Nutrition section
          if (dish.energy.isNotEmpty) ...[
            _buildNutritionSection(),
            const SizedBox(height: 32),
          ],

          // Ingredients
          if (dish.ingredients.isNotEmpty) ...[
            _buildIngredientsSection(),
            const SizedBox(height: 24),
          ],

          // Allergens
          if (dish.allergens.isNotEmpty) ...[_buildAllergensSection()],

          // Bottom spacing for CTA
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDietaryBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: dish.tags.map((tag) {
        final isVegan = tag.toLowerCase() == 'vegan';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isVegan
                ? AppTheme.primary.withValues(alpha: 0.1)
                : const Color(0xFF1E293B).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isVegan
                  ? AppTheme.primary.withValues(alpha: 0.2)
                  : const Color(0xFF334155),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getTagIcon(tag),
                size: 18,
                color: isVegan ? AppTheme.primary : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                tag.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isVegan ? AppTheme.primary : const Color(0xFFCBD5E1),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getTagIcon(String tag) {
    switch (tag.toLowerCase()) {
      case 'vegan':
        return Icons.eco;
      case 'laktosefrei':
        return Icons.no_accounts;
      case 'scharf':
        return Icons.local_fire_department;
      case 'mild':
        return Icons.thermostat;
      case 'regional':
        return Icons.location_on;
      default:
        return Icons.label;
    }
  }

  Widget _buildPricingTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREISE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textTertiary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          // Studierende (highlighted)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Studierende',
                style: TextStyle(fontSize: 16, color: AppTheme.textPrimary),
              ),
              Text(
                '${widget.dish.studentPrice.toStringAsFixed(2).replaceAll('.', ',')} €',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          if (dish.staffPrice > 0) ...[
            const SizedBox(height: 12),
            Divider(color: const Color(0xFF334155), height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bedienstete',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
                Text(
                  '${dish.staffPrice.toStringAsFixed(2).replaceAll('.', ',')} €',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
          if (dish.guestPrice > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gäste',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
                Text(
                  '${dish.guestPrice.toStringAsFixed(2).replaceAll('.', ',')} €',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.analytics, color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text(
              'Inhaltsstoffe / Nährwerte',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.0,
          children: [
            NutritionCard(label: 'Energie', value: dish.energy),
            NutritionCard(label: 'Fett', value: dish.fat),
            NutritionCard(label: 'Kohlenh.', value: dish.carbs),
            NutritionCard(label: 'Eiweiß', value: dish.protein),
          ],
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ZUTATEN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textTertiary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dish.ingredients,
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildAllergensSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALLERGENE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textTertiary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: dish.allergens.map((allergen) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                allergen,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCTA() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark.withValues(alpha: 0.8),
          border: Border(top: BorderSide(color: const Color(0xFF2A3A20))),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.backgroundDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_shopping_cart, size: 22),
                  SizedBox(width: 8),
                  Text('Auf den Speiseplan'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
