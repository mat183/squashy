import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/providers/matches_provider.dart';
import 'package:squashy/widgets/match_item.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  void _removeMatch(WidgetRef ref, Match match) async {
    await ref.read(matchesNotifierProvider.notifier).removeMatch(match);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueMatches = ref.watch(matchesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: leagueMatches.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Text('No resolved matches yet!'),
            );
          }

          final resolvedMatches = matches
              .where((match) => match.status != MatchStatus.scheduled)
              .toList();
          return ListView.builder(
            itemCount: resolvedMatches.length,
            itemBuilder: (ctx, index) {
              final Match match = resolvedMatches[index];
              return Dismissible(
                key: ValueKey(match.id),
                background: Container(
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  _removeMatch(ref, match);
                  ScaffoldMessenger.of(ctx).clearSnackBars();
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('League match has been removed!'),
                    ),
                  );
                },
                child: MatchItem(
                  match: match,
                  onTapItem: () {},
                ),
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
