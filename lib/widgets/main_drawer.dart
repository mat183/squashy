import 'package:flutter/material.dart';
import 'package:squashy/screens/stats.dart';
import 'package:squashy/screens/summary.dart';

enum ScreenType {
  scheduledMatches,
  summary,
  statistics,
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void _navigateToScreen(BuildContext context, ScreenType screen) {
    Navigator.pop(context);
    if (screen != ScreenType.scheduledMatches) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => screen == ScreenType.summary
              ? const SummaryScreen()
              : const StatsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sports_tennis,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text(
                  'Squashy',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Scheduled matches'),
            onTap: () =>
                _navigateToScreen(context, ScreenType.scheduledMatches),
          ),
          ListTile(
            leading: const Icon(Icons.summarize),
            title: const Text('Summary'),
            onTap: () => _navigateToScreen(context, ScreenType.summary),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Statistics'),
            onTap: () => _navigateToScreen(context, ScreenType.statistics),
          ),
        ],
      ),
    );
  }
}
