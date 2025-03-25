import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/repositories/match_repository.dart';

class NewMatchForm extends ConsumerStatefulWidget {
  const NewMatchForm({super.key, this.match});

  final Match? match;

  @override
  ConsumerState<NewMatchForm> createState() => _NewMatchFormState();
}

class _NewMatchFormState extends ConsumerState<NewMatchForm> {
  final _formKey = GlobalKey<FormState>();

  late bool _isEditing;
  late TextEditingController _dateController;
  late int _selectedCourt;
  late DateTime _selectedDate;
  late MatchStatus _matchStatus;

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2025, 12, 31),
      initialDate: DateTime.now(),
    );

    if (pickedDate == null) {
      return;
    }

    TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _dateController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate);
    });
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    final now = DateTime.now();
    final roundedNow = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    setState(() {
      _dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(roundedNow);
      _selectedCourt = 1;
      _selectedDate = roundedNow;
    });
  }

  void _submitForm() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pop(context);
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final matchRepo = MatchRepository();

      if (_isEditing) {
        await matchRepo.replaceMatch(Match(
            id: widget.match!.id,
            userId: user!.uid,
            court: _selectedCourt,
            date: _selectedDate,
            status: _matchStatus));
      } else {
        await matchRepo.addMatch(Match(
          userId: user!.uid,
          court: _selectedCourt,
          date: _selectedDate,
          status: _matchStatus,
        ));
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.match != null;
    final now = DateTime.now();
    final roundedNow = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    _dateController = TextEditingController(
      text: _isEditing
          ? widget.match!.formattedDate
          : DateFormat('yyyy-MM-dd HH:mm').format(roundedNow),
    );
    _selectedCourt = _isEditing ? widget.match!.court : 1;
    _selectedDate = _isEditing ? widget.match!.date : roundedNow;
    _matchStatus = _isEditing ? widget.match!.status : MatchStatus.scheduled;
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_isEditing ? 'Edit' : 'Add'} match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Select court",
                ),
                value: _selectedCourt,
                items: courtNames.entries
                    .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text('${entry.key} (${entry.value})')))
                    .toList(),
                onChanged: (court) {
                  if (court != null) {
                    setState(() {
                      _selectedCourt = court;
                    });
                  }
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Select date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('${_isEditing ? 'Edit' : 'Add'} match'),
                  ),
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text('Reset'),
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
