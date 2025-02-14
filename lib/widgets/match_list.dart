import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/providers/matches_provider.dart';
import 'package:squashy/widgets/main_drawer.dart';
import 'package:squashy/widgets/match_item.dart';
import 'package:squashy/widgets/new_match.dart';

class MatchList extends ConsumerWidget {
  const MatchList({super.key});

  Future<MatchStatus?> _showMatchResultDialog(
      BuildContext context, Match match) {
    return showDialog<MatchStatus>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Match result'),
        content: Text('Court: ${match.court}\n'
            'Date: ${match.formattedDate}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, MatchStatus.win);
            },
            child: const Text('Win'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, MatchStatus.draw);
            },
            child: const Text('Draw'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, MatchStatus.loss);
            },
            child: const Text('Loss'),
          ),
        ],
      ),
    );
  }

  void _editMatch(BuildContext context, WidgetRef ref, Match match) async {
    final editedMatch = await Navigator.push<Match>(
      context,
      MaterialPageRoute(
        builder: (ctx) => NewMatchForm(match: match),
      ),
    );

    if (editedMatch != null) {
      await ref
          .read(matchesNotifierProvider.notifier)
          .replaceMatch(editedMatch);
    }
  }

  void _resolveMatch(BuildContext context, WidgetRef ref, Match match) async {
    final status = await _showMatchResultDialog(context, match);

    if (status != null) {
      await ref
          .watch(matchesNotifierProvider.notifier)
          .updateMatch(match, status);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('League match resolved and moved to summary tab!'),
        ));
      }
    }
  }

  void _removeMatch(WidgetRef ref, Match match) async {
    await ref.read(matchesNotifierProvider.notifier).removeMatch(match);
  }

  void _addMatch(BuildContext context, WidgetRef ref, [Match? match]) async {
    if (match != null) {
      return await ref.read(matchesNotifierProvider.notifier).addMatch(match);
    }

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
    final leagueMatches = ref.watch(matchesNotifierProvider);

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
                      // children: [
                      //   const Divider(),
                      //   Padding(
                      //     padding: const EdgeInsets.all(2),
                      //     child: AspectRatio(
                      //       aspectRatio: 1,
                      //       child: Image.asset(
                      //         'assets/flutterfire_300x.png',
                      //       ),
                      //     ),
                      //   ),
                      // ],
                    ),
                  ));
            },
          ),
        ],
      ),
      body: leagueMatches.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Text('No matches found! Try to create one.'),
            );
          }

          final scheduledMatches = matches
              .where((match) => match.status == MatchStatus.scheduled)
              .toList();
          return ListView.builder(
            itemCount: scheduledMatches.length,
            itemBuilder: (ctx, index) {
              final Match match = scheduledMatches[index];
              return Dismissible(
                key: ValueKey(match.id),
                background: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return true;
                  } else {
                    _resolveMatch(ctx, ref, match);
                    return false;
                  }
                },
                onDismissed: (direction) {
                  _removeMatch(ref, match);
                  ScaffoldMessenger.of(ctx).clearSnackBars();
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                    content: const Text('League match has been removed!'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        _addMatch(ctx, ref, match);
                      },
                    ),
                  ));
                },
                child: MatchItem(
                  match: match,
                  onTapItem: () => _editMatch(ctx, ref, match),
                ),
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addMatch(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
