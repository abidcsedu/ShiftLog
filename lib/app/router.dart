import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/providers.dart';
import '../ui/dashboard_screen.dart';
import '../ui/history_screen.dart';
import '../ui/main_shell.dart';
import '../ui/monthly_screen.dart';
import '../ui/settings_screen.dart';
import '../ui/setup_screen.dart';

/// Tracks just enough auth-like state (has the user completed setup?) to drive
/// the setup<->app redirect, without rebuilding the whole router on every
/// settings change (which would tear down the StatefulShellRoute and crash).
class _SetupState extends ChangeNotifier {
  bool loading = true;
  bool hasSettings = false;

  void update({required bool loading, required bool hasSettings}) {
    if (this.loading == loading && this.hasSettings == hasSettings) return;
    this.loading = loading;
    this.hasSettings = hasSettings;
    notifyListeners();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  // Built ONCE. We listen (not watch) so settings changes don't recreate it.
  final setupState = _SetupState();
  ref.onDispose(setupState.dispose);
  ref.listen(settingsProvider, (_, next) {
    setupState.update(loading: next.isLoading, hasSettings: next.value != null);
  }, fireImmediately: true);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: setupState,
    redirect: (context, state) {
      if (setupState.loading) return null;
      final atSetup = state.matchedLocation == '/setup';
      if (!setupState.hasSettings && !atSetup) return '/setup';
      if (setupState.hasSettings && atSetup) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, _) => const DashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/insights', builder: (_, _) => const MonthlyScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/history', builder: (_, _) => const HistoryScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/settings', builder: (_, _) => const SettingsScreen()),
          ]),
        ],
      ),
    ],
  );
});
