import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Persistent bottom navigation shell hosting the 4 top-level tabs.
/// Each tab keeps its own state/scroll via StatefulShellRoute.indexedStack.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  static const _destinations = [
    _Dest(Icons.home_outlined, Icons.home, 'Home'),
    _Dest(Icons.sticky_note_2_outlined, Icons.sticky_note_2, 'Notes'),
    _Dest(Icons.insights_outlined, Icons.insights, 'Insights'),
    _Dest(Icons.calendar_month_outlined, Icons.calendar_month, 'History'),
    _Dest(Icons.settings_outlined, Icons.settings, 'Settings'),
  ];

  void _onTap(int index) => navigationShell.goBranch(
        index,
        // Re-tapping the active tab pops it to its initial route.
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

class _Dest {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _Dest(this.icon, this.selectedIcon, this.label);
}
