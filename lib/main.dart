import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/mensa_discovery_screen.dart';

void main() {
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
