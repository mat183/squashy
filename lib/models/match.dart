import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MatchStatus {
  scheduled,
  resolved,
  cancelled,
}

const Map<MatchStatus, Icon> statusIcons = {
  MatchStatus.scheduled: Icon(Icons.schedule),
  MatchStatus.resolved: Icon(Icons.check),
  MatchStatus.cancelled: Icon(Icons.close),
};

// TODO: to be fulfilled during the year :)
const Map<int, String> courtNames = {
  1: '1',
  2: 'SARAGOSSA (2)',
  3: 'SANTA CRUZ (3)',
  4: 'GRENADA (4)',
  5: 'BARCELONA (5)',
  6: 'MADRYT (6)',
  7: '7',
  8: '8',
  9: '9',
  10: '10',
  11: '11',
  12: '12',
  13: '13',
  14: '14',
  15: '15',
  16: '16',
  17: '17',
  18: '18',
  19: '19',
  20: '20',
  21: '21',
  22: '22',
  23: '23',
  24: '24',
  25: '25',
  26: '26',
  27: '27',
  28: '28',
  29: '29',
  30: '30',
  31: '31',
  32: '32',
};

class Match {
  const Match(
      {required this.id,
      required this.userId,
      required this.court,
      required this.date,
      required this.status});

  final String id;
  final String userId;
  final int court;
  final DateTime date;
  final MatchStatus status;

  String get formattedDate => DateFormat('yyyy-MM-dd HH:mm').format(date);
}
