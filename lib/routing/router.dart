import "package:go_router/go_router.dart";

import "package:mensa_app/routing/routes.dart";
import "package:mensa_app/screens/dish_detail_screen.dart";
import "package:mensa_app/screens/mensa_discovery_screen.dart";

GoRouter createRouter() {
  return GoRouter(
    routes: [
      // Main Navigation Scaffold with bottom navigation bar
      StatefulShellRoute.indexedStack(
        branches: [
          //
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.mensaDiscovery,
                name: Routes.mensaDiscoveryRelative,
                builder: (context, state) => MensaDiscoveryScreen(),
                routes: [
                  GoRoute(
                    // The child's path is concatenated on parent [GoRoute.path]
                    path: Routes.dishDetailRelative,
                    name: Routes.dishDetailRelative,
                    // TODO: Add DI with provider package to resolve errors
                    builder: (context, state) =>
                        DishDetailScreen(dish: dish, mensa: mensa),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
