import 'package:flutter/material.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/models/result.dart';

class ResultItem extends StatelessWidget {
  const ResultItem({
    super.key,
    required this.match,
    required this.result,
  });

  final Match match;
  final Result result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: verdictIcons[result.verdict],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result.setsWon.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Text(
              ':',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Text(
              result.setsLost.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(match.formattedDate),
            Text(
              'Court: ${courtNames[match.court]!}',
              // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // trailing: Text(
        //   courtNames[match.court]!,
        //   style: const TextStyle(
        //     fontSize: 12,
        //   ),
        // ),
      ),
    );
  }
}
