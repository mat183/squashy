import 'dart:math';

import 'package:flutter/material.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/repositories/match_repository.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _totalMatches = 0;
  int _totalSets = 0;
  int _setsWon = 0;
  int _setsLost = 0;
  int _winStreak = 0;
  int _highestWinStreak = 0;
  double _setsRatio = 0.0;

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<List<Match>> _fetchMatches() async {
    final fetchedMatches = await MatchRepository().fetchMatches();
    return fetchedMatches
        .where((match) => match.status == MatchStatus.resolved)
        .toList();
  }

  Future<void> _calculateStats() async {
    final matches = await _fetchMatches();
    int totalMatches = matches.length;
    int setsWon = 0;
    int setsLost = 0;
    int winStreak = 0;
    int highestWinStreak = 0;
    for (Match match in matches) {
      setsWon += match.setsWon;
      setsLost += match.setsLost;
      winStreak = match.setsWon > match.setsLost ? winStreak + 1 : 0;
      highestWinStreak = max(highestWinStreak, winStreak);
    }
    final int totalSets = setsWon + setsLost;
    final double setsRatio =
        totalMatches > 0 ? (totalSets / totalMatches.toDouble()) : 0.0;

    setState(() {
      _totalMatches = totalMatches;
      _totalSets = totalSets;
      _setsWon = setsWon;
      _setsLost = setsLost;
      _winStreak = winStreak;
      _highestWinStreak = highestWinStreak;
      _setsRatio = setsRatio;
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard('Total matches', _totalMatches.toString()),
            _buildStatCard('Total sets played', _totalSets.toString()),
            _buildStatCard('Sets won', _setsWon.toString()),
            _buildStatCard('Sets lost', _setsLost.toString()),
            _buildStatCard(
                'Sets ratio per match', _setsRatio.toStringAsFixed(2)),
            _buildStatCard('Current win streak', _winStreak.toString()),
            _buildStatCard('Highest win streak', _highestWinStreak.toString()),
          ],
        ),
      ),
    );
  }
}
