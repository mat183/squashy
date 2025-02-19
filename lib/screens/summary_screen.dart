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
    final allMatches = ref.watch(matchesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: allMatches.when(
        data: (matches) {
          final resolvedMatches = matches
              .where((match) => match.status != MatchStatus.scheduled)
              .toList();

          if (resolvedMatches.isEmpty) {
            return const Center(
              child: Text('No resolved matches yet!'),
            );
          }

          final wins = resolvedMatches
              .where((match) => match.status == MatchStatus.win)
              .length;
          final draws = resolvedMatches
              .where((match) => match.status == MatchStatus.draw)
              .length;
          final losses = resolvedMatches
              .where((match) => match.status == MatchStatus.loss)
              .length;
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Total Matches: ${resolvedMatches.length}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Wins: $wins",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 16)),
                          Text("Draws: $draws",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16)),
                          Text("Losses: $losses",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text("Results:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
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
                        onLongPressItem: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (error, stack) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
