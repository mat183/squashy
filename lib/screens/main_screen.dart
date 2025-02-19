import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/providers/matches_provider.dart';
import 'package:squashy/widgets/main_drawer.dart';
import 'package:squashy/widgets/match_list.dart';
import 'package:squashy/screens/new_match.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  void _addMatch(BuildContext context, WidgetRef ref) async {
    final newMatch = await Navigator.push<Match>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewMatchForm(),
      ),
    );

    if (newMatch != null) {
      await ref.read(matchesNotifierProvider.notifier).addMatch(newMatch);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Squash league'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ProfileScreen(
                      appBar: AppBar(
                        title: const Text('User Profile'),
                      ),
                      actions: [
                        SignedOutAction(
                          (ctx) => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ],
      ),
      body: const MatchList(),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMatch(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
