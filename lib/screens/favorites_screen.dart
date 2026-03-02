import 'package:flutter/material.dart';
import '../models/favorite_dish.dart';
import '../models/dish.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import '../widgets/favorite_dish_card.dart';

class FavoritesScreen extends StatefulWidget {
  final Map<String, String>
  availableTodayDishes; // dishName -> Mensa Name offering it today

  const FavoritesScreen({super.key, required this.availableTodayDishes});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  String _selectedMensaFilter = 'all'; // 'all' or specific Mensa.id

  // Controls for accordion sections (expanded by default)
  final Map<String, bool> _expandedSections = {
    'hauptgericht': true,
    'snack': true,
    'beilage': true,
    'dessert': true,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: StreamBuilder(
            stream: _favoritesService.watchFavorites(),
            builder: (context, snapshot) {
              final favorites = _favoritesService.getFavorites(
                mensaId: _selectedMensaFilter == 'all'
                    ? null
                    : _selectedMensaFilter,
              );

              if (favorites.isEmpty) {
                return _buildEmptyState();
              }

              // Group by category manually to enforce sequence
              final hauptgerichte = favorites
                  .where((f) => f.displayCategory == 'hauptgericht')
                  .toList();
              final snacks = favorites
                  .where((f) => f.displayCategory == 'snack')
                  .toList();
              final beilagen = favorites
                  .where((f) => f.displayCategory == 'beilage')
                  .toList();
              final desserts = favorites
                  .where((f) => f.displayCategory == 'dessert')
                  .toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  children: [
                    if (hauptgerichte.isNotEmpty)
                      _buildCollapsibleSection(
                        'Hauptgerichte',
                        'hauptgericht',
                        Icons.restaurant,
                        hauptgerichte,
                      ),
                    if (snacks.isNotEmpty)
                      _buildCollapsibleSection(
                        'Snacks',
                        'snack',
                        Icons.fastfood,
                        snacks,
                      ),
                    if (beilagen.isNotEmpty)
                      _buildCollapsibleSection(
                        'Beilagen',
                        'beilage',
                        Icons.lunch_dining,
                        beilagen,
                      ),
                    if (desserts.isNotEmpty)
                      _buildCollapsibleSection(
                        'Desserts',
                        'dessert',
                        Icons.icecream,
                        desserts,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(color: AppTheme.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Favoriten',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const Spacer(),
                  _buildMensaFilterDropdown(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppTheme.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Noch keine Favoriten',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Markiere Gerichte im Speiseplan mit\ndem Herz-Symbol, um sie hier zu speichern.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textTertiary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMensaFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMensaFilter,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          isDense: true,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedMensaFilter = newValue;
              });
            }
          },
          items: [
            const DropdownMenuItem(value: 'all', child: Text('Alle Mensen')),
            ...Mensa.all.map(
              (m) => DropdownMenuItem(value: m.id, child: Text(m.displayName)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection(
    String title,
    String sectionKey,
    IconData icon,
    List<FavoriteDish> dishes,
  ) {
    final isExpanded = _expandedSections[sectionKey] ?? true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[sectionKey] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(icon, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '${dishes.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppTheme.textTertiary,
                  ),
                ],
              ),
            ),
          ),

          // Grid Content
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Taller than wide
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  final dish = dishes[index];
                  final availableMensa = widget
                      .availableTodayDishes[dish.name.trim().toLowerCase()];
                  return FavoriteDishCard(
                    dish: dish,
                    isAvailableToday: availableMensa != null,
                    availableTodayMensa: availableMensa,
                    onUnfavorite: () async {
                      await dish.delete();
                    },
                  );
                },
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
