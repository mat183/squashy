import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/providers/match_provider.dart';
import 'package:squashy/forms/resolve_match.dart';
import 'package:squashy/widgets/match_item.dart';
import 'package:squashy/forms/new_match.dart';

class MatchList extends ConsumerWidget {
  const MatchList({super.key});

  Future<bool?> _confirmMatchRemove(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm match removal'),
        content: const Text('Are you sure you want to remove the match?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Remove", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _editMatch(BuildContext context, Match match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => NewMatchForm(match: match),
      ),
    );
  }

  void _resolveMatch(BuildContext context, Match match) async {
    final isResolved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (ctx) => ResolveMatchForm(matchId: match.id)),
    );
    if (context.mounted && isResolved != null && isResolved) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('League match resolved and result moved to summary tab!'),
      ));
    }
  }

  void _removeMatch(WidgetRef ref, Match match) async {
    await ref.read(matchNotifierProvider.notifier).removeMatch(match.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMatches = ref.watch(matchStreamProvider);

    return allMatches.when(
      data: (matches) {
        final scheduledMatches = matches
            .where((match) => match.status == MatchStatus.scheduled)
            .toList();

        if (scheduledMatches.isEmpty) {
          return const Center(
            child: Text('No matches found! Try to create one.'),
          );
        }

        return ListView.builder(
          itemCount: scheduledMatches.length,
          itemBuilder: (ctx, index) {
            final Match match = scheduledMatches[index];
            return Dismissible(
              key: ValueKey(match.id),
              background: Container(
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) => _confirmMatchRemove(ctx),
              onDismissed: (direction) {
                _removeMatch(ref, match);
                ScaffoldMessenger.of(ctx).clearSnackBars();
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content: const Text('League match has been removed!'),
                ));
              },
              child: MatchItem(
                match: match,
                onTapItem: () => _editMatch(ctx, match),
                onLongPressItem: () => _resolveMatch(ctx, match),
              ),
            );
          },
        );
      },
      error: (error, stack) => Center(child: Text("Error: $error")),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
