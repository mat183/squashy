import 'package:flutter/material.dart';
import 'package:squashy/models/match.dart';

class MatchItem extends StatelessWidget {
  const MatchItem({
    super.key,
    required this.match,
    required this.onTapItem,
  });

  final Match match;
  final void Function() onTapItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: statusIcons[match.status],
        title: Text(match.formattedDate),
        trailing: Text(
          courtNames[match.court]!,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        onTap: onTapItem,
      ),
    );
  }
}
