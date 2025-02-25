import 'package:flutter/material.dart';

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

class Result {
  const Result(
      {required this.id,
      required this.matchId,
      required this.userId,
      required this.setsWon,
      required this.setsLost,
      required this.verdict});

  final String id;
  final String matchId;
  final String userId;
  final int setsWon;
  final int setsLost;
  final MatchVerdict verdict;
}
