import 'package:flutter/material.dart';
import 'package:squashy/models/match.dart';

class ResultItem extends StatelessWidget {
  const ResultItem({
    super.key,
    required this.match,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final verdict = match.setsWon > match.setsLost
        ? MatchVerdict.win
        : match.setsWon < match.setsLost
            ? MatchVerdict.loss
            : MatchVerdict.draw;
    return Card(
      child: ListTile(
        leading: verdictIcons[verdict],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              match.setsWon.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Text(
              ':',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Text(
              match.setsLost.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(match.formattedDate),
            Text('Court: ${courtNames[match.court]!}'),
          ],
        ),
      ),
    );
  }
}
