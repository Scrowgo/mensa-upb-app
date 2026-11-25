import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:mensa_app/data/repositories/repositories.dart';
import 'package:mensa_app/data/services/services.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';
import 'hive/hive_registrar.g.dart';
import 'routing/router.dart';
import 'services/favorites_service.dart';
import 'theme/app_theme.dart';
import 'ui/core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapters();
  await FavoritesService().init();

  runApp(
    MultiProvider(
      providers: [
        // === Services ===
        Provider(create: (context) => HiveService()),
        Provider(create: (context) => MensaApiService()),
        // === Repositories ===
        Provider(
          create: (context) =>
              DishRepositoryRemote(
                    hiveService: context.read<HiveService>(),
                    mensaApiService: context.read<MensaApiService>(),
                  )
                  as DishRepository,
        ),
      ],
      child: MixScope(
        colors: DarkGreenTheme.colors,
        textStyles: DarkGreenTheme.textStyles,
        radii: DarkGreenTheme.radii,
        spaces: DarkGreenTheme.spaces,
        child: const MensaApp(),
      ),
    ),
  );
}

class MensaApp extends StatefulWidget {
  const MensaApp({super.key});

  @override
  State<MensaApp> createState() => _MensaAppState();
}

class _MensaAppState extends State<MensaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EatUPB',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          AppTheme.darkTheme.textTheme,
        ),
      ),
      routerConfig: _router,
    );
  }
}
