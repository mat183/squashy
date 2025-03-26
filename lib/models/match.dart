import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum MatchStatus {
  scheduled,
  resolved,
  cancelled,
}

enum MatchVerdict {
  win,
  loss,
  draw,
}

const Map<MatchVerdict, Icon> verdictIcons = {
  MatchVerdict.win: Icon(
    Icons.check_circle,
    color: Colors.green,
  ),
  MatchVerdict.loss: Icon(
    Icons.cancel,
    color: Colors.red,
  ),
  MatchVerdict.draw: Icon(
    Icons.do_disturb_on,
    color: Colors.blue,
  )
};

const Map<MatchStatus, Icon> statusIcons = {
  MatchStatus.scheduled: Icon(Icons.schedule),
  MatchStatus.resolved: Icon(Icons.check),
  MatchStatus.cancelled: Icon(Icons.close),
};

// TODO: to be fulfilled during the year :)
const Map<int, String> courtNames = {
  1: '1',
  2: 'SARAGOSSA',
  3: 'SANTA CRUZ',
  4: 'GRENADA',
  5: 'BARCELONA',
  6: 'MADRYT',
  7: 'ALICANTE',
  8: 'SEWILLA',
  9: 'TOLEDO',
  10: 'IBIZA',
  11: 'MALAGA',
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
  Match({
    required this.userId,
    required this.court,
    required this.date,
    this.setsWon = 0,
    this.setsLost = 0,
    this.status = MatchStatus.scheduled,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String userId;
  final int court;
  final DateTime date;
  final int setsWon;
  final int setsLost;
  final MatchStatus status;

  String get formattedDate => DateFormat('yyyy-MM-dd HH:mm').format(date);
}
