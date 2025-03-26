import 'package:flutter/material.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/repositories/match_repository.dart';
import 'package:squashy/widgets/result_item.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _matchRepo = MatchRepository();

  Future<void> _removeResult(String matchId) async {
    await _matchRepo.removeMatch(matchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: StreamBuilder(
        stream: _matchRepo.watchMatchesDescending(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!
                  .where((match) => match.status == MatchStatus.resolved)
                  .isEmpty) {
            return const Center(
              child: Text('No resolved matches yet!'),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final resolvedMatches = snapshot.data!
              .where((match) => match.status == MatchStatus.resolved)
              .toList();
          final wins = resolvedMatches
              .where((match) => match.setsWon > match.setsLost)
              .length;
          final draws = resolvedMatches
              .where((match) => match.setsWon == match.setsLost)
              .length;
          final losses = resolvedMatches
              .where((match) => match.setsWon < match.setsLost)
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
                        _removeResult(match.id);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).clearSnackBars();
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text('League match has been removed!'),
                            ),
                          );
                        }
                      },
                      child: ResultItem(
                        match: match,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
