import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'hive/hive_registrar.g.dart';
import 'services/favorites_service.dart';
import 'theme/app_theme.dart';
import 'screens/mensa_discovery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapters();
  await FavoritesService().init();

  runApp(const MensaApp());
}

class MensaApp extends StatelessWidget {
  const MensaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mensa Discovery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          AppTheme.darkTheme.textTheme,
        ),
      ),
      home: const MensaDiscoveryScreen(),
    );
  }
}
