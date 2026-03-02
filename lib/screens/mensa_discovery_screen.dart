import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../services/mensa_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/dish_card.dart';
import '../widgets/side_item_row.dart';
import 'dish_detail_screen.dart';

class MensaDiscoveryScreen extends StatefulWidget {
  const MensaDiscoveryScreen({super.key});

  @override
  State<MensaDiscoveryScreen> createState() => _MensaDiscoveryScreenState();
}

class _MensaDiscoveryScreenState extends State<MensaDiscoveryScreen> {
  int _selectedNavIndex = 0;
  int _selectedMensaIndex = 0;

  late PageController _pageController;
  late List<DateTime> _weekDays;
  int _selectedDayIndex = 0;

  // Cache: key = "venue_date"
  final Map<String, List<Dish>> _cache = {};
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initWeekDays();
    _pageController = PageController(initialPage: _selectedDayIndex);
    _loadMeals();
  }

  void _initWeekDays() {
    // Find the Monday of the current week
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _weekDays = List.generate(5, (i) => monday.add(Duration(days: i)));

    // Select today if it's a weekday, otherwise Monday
    final todayIndex = _weekDays.indexWhere(
      (d) => d.year == now.year && d.month == now.month && d.day == now.day,
    );
    _selectedDayIndex = todayIndex >= 0 ? todayIndex : 0;
  }

  String _cacheKey(String venue, DateTime date) =>
      '${venue}_${MensaApiService.formatDate(date)}';

  Future<void> _loadMeals() async {
    final venue = Mensa.all[_selectedMensaIndex].id;
    final date = _weekDays[_selectedDayIndex];
    final key = _cacheKey(venue, date);

    if (_cache.containsKey(key)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Fetch the entire week at once for efficiency
    try {
      final weekData = await MensaApiService.fetchWeek(
        venue: venue,
        weekStart: _weekDays.first,
      );

      setState(() {
        // Cache all days from this response
        for (final day in _weekDays) {
          final dateStr = MensaApiService.formatDate(day);
          final k = _cacheKey(venue, day);
          _cache[k] = weekData[dateStr] ?? [];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Fehler beim Laden der Daten';
      });
    }
  }

  void _navigateToDetail(Dish dish) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DishDetailScreen(dish: dish)),
    );
  }

  void _switchMensa(int direction) {
    setState(() {
      _selectedMensaIndex =
          (_selectedMensaIndex + direction) % Mensa.all.length;
      if (_selectedMensaIndex < 0) {
        _selectedMensaIndex = Mensa.all.length - 1;
      }
    });
    _loadMeals();
  }

  String _formatDayLabel(DateTime date) {
    const days = ['MO', 'DI', 'MI', 'DO', 'FR', 'SA', 'SO'];
    return days[date.weekday - 1];
  }

  String _formatDateLabel(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _weekDays.length,
                  onPageChanged: (index) {
                    setState(() => _selectedDayIndex = index);
                    _loadMeals();
                  },
                  itemBuilder: (context, index) {
                    return _buildDayContent(index);
                  },
                ),
              ),
            ],
          ),
          _buildMensaSelector(),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildDayContent(int dayIndex) {
    final venue = Mensa.all[_selectedMensaIndex].id;
    final date = _weekDays[dayIndex];
    final key = _cacheKey(venue, date);
    final meals = _cache[key];

    if (_isLoading && meals == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      );
    }

    if (_errorMessage != null && meals == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppTheme.primary, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMeals,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.backgroundDark,
              ),
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
    }

    final dayMeals = meals ?? [];

    if (dayMeals.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.no_meals, color: AppTheme.textTertiary, size: 64),
            const SizedBox(height: 16),
            Text(
              'Keine Gerichte verfügbar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'An diesem Tag gibt es keinen Speiseplan.',
              style: TextStyle(fontSize: 14, color: AppTheme.textTertiary),
            ),
          ],
        ),
      );
    }

    // Group by display category
    final hauptgerichte = dayMeals
        .where((d) => d.displayCategory == 'hauptgericht')
        .toList();
    final beilagen = dayMeals
        .where((d) => d.displayCategory == 'beilage')
        .toList();
    final desserts = dayMeals
        .where((d) => d.displayCategory == 'dessert')
        .toList();
    final snacks = dayMeals.where((d) => d.displayCategory == 'snack').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hauptgerichte.isNotEmpty) ...[
            _buildSection(
              icon: Icons.restaurant,
              title: 'Hauptgerichte',
              count: hauptgerichte.length,
              dishes: hauptgerichte,
              isLarge: true,
            ),
            const SizedBox(height: 32),
          ],
          if (snacks.isNotEmpty) ...[
            _buildSection(
              icon: Icons.fastfood,
              title: 'Snacks',
              count: snacks.length,
              dishes: snacks,
              isLarge: true,
            ),
            const SizedBox(height: 32),
          ],
          if (beilagen.isNotEmpty) ...[
            _buildSection(
              icon: Icons.lunch_dining,
              title: 'Beilagen',
              dishes: beilagen,
              isLarge: false,
            ),
            const SizedBox(height: 32),
          ],
          if (desserts.isNotEmpty) ...[
            _buildSection(
              icon: Icons.icecream,
              title: 'Desserts',
              dishes: desserts,
              isLarge: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    int? count,
    required List<Dish> dishes,
    bool isLarge = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
              ],
            ),
            if (count != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  '$count Gerichte',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLarge)
          ...dishes.map(
            (dish) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DishCard(
                dish: dish,
                onDetailsTap: () => _navigateToDetail(dish),
                onFavoriteTap: () {
                  setState(() => dish.isFavorite = !dish.isFavorite);
                },
              ),
            ),
          )
        else
          ...dishes.map(
            (dish) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => _navigateToDetail(dish),
                child: SideItemRow(dish: dish),
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(Icons.menu),
                  const Text(
                    'Mensa Discovery',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  _buildIconButton(
                    Icons.account_circle,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _weekDays.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedDayIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDayIndex = index);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      _loadMeals();
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatDayLabel(_weekDays[index]),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDateLabel(_weekDays[index]),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {Color color = AppTheme.textPrimary}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildMensaSelector() {
    return Positioned(
      bottom: 80,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _switchMensa(-1),
              child: _buildNavArrowButton(Icons.chevron_left),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AUSGEWÄHLTE MENSA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textTertiary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Mensa.all[_selectedMensaIndex].displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => _switchMensa(1),
              child: _buildNavArrowButton(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavArrowButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppTheme.primary, size: 24),
    );
  }

  Widget _buildBottomNav() {
    final navItems = [
      {'icon': Icons.restaurant_menu, 'label': 'Speiseplan'},
      {'icon': Icons.favorite, 'label': 'Favoriten'},
      {'icon': Icons.map, 'label': 'Campus'},
      {'icon': Icons.person, 'label': 'Profil'},
    ];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark,
          border: Border(top: BorderSide(color: const Color(0xFF2A3A20))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(navItems.length, (index) {
            final isSelected = index == _selectedNavIndex;
            return GestureDetector(
              onTap: () => setState(() => _selectedNavIndex = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    navItems[index]['icon'] as IconData,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textTertiary,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    navItems[index]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
