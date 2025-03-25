import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
    Icons.compare_arrows,
    color: Colors.blue,
  )
};

const uuid = Uuid();

class Result {
  Result(
      {required this.matchId,
      required this.userId,
      required this.setsWon,
      required this.setsLost,
      required this.verdict,
      String? id})
      : id = id ?? uuid.v4();

  final String id;
  final String matchId;
  final String userId;
  final int setsWon;
  final int setsLost;
  final MatchVerdict verdict;
}
