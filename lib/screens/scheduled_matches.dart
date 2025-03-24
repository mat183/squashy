import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/providers/match_provider.dart';
import 'package:squashy/widgets/main_drawer.dart';
import 'package:squashy/widgets/match_list.dart';
import 'package:squashy/forms/new_match.dart';

class ScheduledMatchesScreen extends ConsumerStatefulWidget {
  const ScheduledMatchesScreen({super.key});

  @override
  ConsumerState<ScheduledMatchesScreen> createState() =>
      _ScheduledMatchesScreenState();
}

class _ScheduledMatchesScreenState
    extends ConsumerState<ScheduledMatchesScreen> {
  void _addMatch(BuildContext context, WidgetRef ref) async {
    final newMatch = await Navigator.push<Match>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewMatchForm(),
      ),
    );

    if (newMatch != null) {
      await ref.read(matchNotifierProvider.notifier).addMatch(newMatch);
    }
  }

  Future<void> _setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('matches');
  }

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled matches'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: const MatchList(),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMatch(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
