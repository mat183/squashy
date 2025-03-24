import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/models/result.dart';
import 'package:squashy/providers/match_provider.dart';
import 'package:squashy/providers/result_provider.dart';
import 'package:squashy/widgets/result_item.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  void _removeResult(WidgetRef ref, Result result) async {
    await ref.read(resultNotifierProvider.notifier).removeResult(result.id);
    await ref.read(matchNotifierProvider.notifier).removeMatch(result.matchId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allResults = ref.watch(resultStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: allResults.when(
        data: (results) {
          final resolvedMatches = ref
              .read(matchStreamProvider)
              .requireValue
              .where((match) => match.status == MatchStatus.resolved)
              .toList();

          if (resolvedMatches.isEmpty) {
            return const Center(
              child: Text('No resolved matches yet!'),
            );
          }

          final wins = results
              .where((result) => result.verdict == MatchVerdict.win)
              .length;
          final draws = results
              .where((result) => result.verdict == MatchVerdict.draw)
              .length;
          final losses = results
              .where((result) => result.verdict == MatchVerdict.loss)
              .length;
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Total Matches: ${results.length}",
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
                  itemCount: results.length,
                  itemBuilder: (ctx, index) {
                    final Result result = results[index];
                    final Match match = resolvedMatches
                        .firstWhere((m) => m.id == result.matchId);
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
                        _removeResult(ref, result);
                        ScaffoldMessenger.of(ctx).clearSnackBars();
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('League match has been removed!'),
                          ),
                        );
                      },
                      child: ResultItem(
                        match: match,
                        result: result,
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
