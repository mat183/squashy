import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/repositories/match_repository.dart';

class ResolveMatchForm extends StatefulWidget {
  const ResolveMatchForm({super.key, required this.matchId});

  final String matchId;

  @override
  State<ResolveMatchForm> createState() => _ResolveMatchFormState();
}

class _ResolveMatchFormState extends State<ResolveMatchForm> {
  final _formKey = GlobalKey<FormState>();
  final _matchRepo = MatchRepository();

  int _myScore = 0;
  int _opponentsScore = 0;

  void _cancelForm() {
    Navigator.pop(context, false);
  }

  void _submitForm() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in!');
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _matchRepo.updateMatch(
        widget.matchId,
        {
          'userId': user.uid,
          'setsWon': _myScore,
          'setsLost': _opponentsScore,
          'status': MatchStatus.resolved.toString().split('.').last,
        },
      );

      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resolve match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _myScore.toString(),
                decoration: const InputDecoration(
                  labelText: 'Sets won',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) < 0) {
                    return 'Please enter positive value of your score';
                  }
                  return null;
                },
                onSaved: (score) {
                  _myScore = int.parse(score!);
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                initialValue: _opponentsScore.toString(),
                decoration: const InputDecoration(
                  labelText: 'Sets lost',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) < 0) {
                    return 'Please enter positive value of opponent\'s score';
                  }
                  return null;
                },
                onSaved: (score) {
                  _opponentsScore = int.parse(score!);
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Confirm'),
                  ),
                  TextButton(
                    onPressed: _cancelForm,
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
