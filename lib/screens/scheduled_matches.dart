import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:squashy/widgets/main_drawer.dart';
import 'package:squashy/widgets/match_list.dart';
import 'package:squashy/forms/new_match.dart';

class ScheduledMatchesScreen extends StatefulWidget {
  const ScheduledMatchesScreen({super.key});

  @override
  State<ScheduledMatchesScreen> createState() => _ScheduledMatchesScreenState();
}

class _ScheduledMatchesScreenState extends State<ScheduledMatchesScreen> {
  void _addMatch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewMatchForm(),
      ),
    );
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
        onPressed: _addMatch,
        child: const Icon(Icons.add),
      ),
    );
  }
}
