import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/actions_screen.dart';
import '../screens/directions_screen.dart';
import '../screens/family_screen.dart';
import '../screens/home_screen.dart';
import '../screens/info_screen.dart';
import '../screens/map_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/route_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/shelters_screen.dart';
import '../screens/warning_details_screen.dart';
import '../widgets/nav_shell.dart';

/// All routes. The four bottom-nav tabs live inside a StatefulShellRoute;
/// the remaining screens are pushed on top so they're reachable from anywhere.
class AppRouter {
  AppRouter._();

  static final _rootKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            NavShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/map',
                builder: (context, state) => const MapScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/family',
                builder: (context, state) => const FamilyScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/info',
                builder: (context, state) => const InfoScreen()),
          ]),
        ],
      ),
      // Pushed full-screen routes.
      GoRoute(
        path: '/warning',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const WarningDetailsScreen(),
      ),
      GoRoute(
        path: '/actions',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ActionsScreen(),
      ),
      GoRoute(
        path: '/shelters',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SheltersScreen(),
      ),
      GoRoute(
        path: '/directions',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const DirectionsScreen(),
      ),
      GoRoute(
        path: '/route',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const RouteScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
