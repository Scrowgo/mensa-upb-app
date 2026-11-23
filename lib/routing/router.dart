import "package:go_router/go_router.dart";
import "package:material_ui/material_ui.dart";

import "package:mensa_app/routing/routes.dart";

GoRouter createRouter() {
  return GoRouter(
    routes: [
      // Main Navigation Scaffold with bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Speisepläne
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.mensaDiscovery,
                name: Routes.mensaDiscoveryRelative,
                builder: (context, state) => Placeholder(),
                routes: [
                  // GoRoute(
                  //   // The child's path is concatenated on parent [GoRoute.path]
                  //   path: Routes.dishDetailRelative,
                  //   name: Routes.dishDetailRelative,
                  //   // TODO: Add DI with provider package to resolve errors
                  //   builder: (context, state) =>
                  //       DishDetailScreen(dish: dish, mensa: mensa),
                  // ),
                ],
              ),
            ],
          ),
          // Favoriten
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.favorites,
                name: Routes.favoritesRelative,
                builder: (context, state) => Placeholder(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: "Speiseplan",
          ),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Favoriten"),
        ],
      ),
    );
  }
}
