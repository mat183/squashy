import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squashy/models/match.dart';

class MatchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Match>> watchMatches() {
    return _firestore
        .collection('matches')
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Match(
                  id: doc.id,
                  userId: doc.get('userId'),
                  court: doc.get('court'),
                  date: doc.get('date').toDate(),
                  setsWon: doc.get('setsWon'),
                  setsLost: doc.get('setsLost'),
                  status: MatchStatus.values.byName(doc.get('status')),
                ))
            .toList());
  }

  Stream<List<Match>> watchMatchesDescending() {
    return _firestore
        .collection('matches')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Match(
                  id: doc.id,
                  userId: doc.get('userId'),
                  court: doc.get('court'),
                  date: doc.get('date').toDate(),
                  setsWon: doc.get('setsWon'),
                  setsLost: doc.get('setsLost'),
                  status: MatchStatus.values.byName(doc.get('status')),
                ))
            .toList());
  }

  Future<List<Match>> fetchMatches() async {
    final querySnapshot =
        await _firestore.collection('matches').orderBy('date').get();
    return querySnapshot.docs
        .map((doc) => Match(
              id: doc.id,
              userId: doc.get('userId'),
              court: doc.get('court'),
              date: doc.get('date').toDate(),
              setsWon: doc.get('setsWon'),
              setsLost: doc.get('setsLost'),
              status: MatchStatus.values.byName(doc.get('status')),
            ))
        .toList();
  }

  Future<void> addMatch(Match match) async {
    final matchRef = _firestore.collection('matches').doc(match.id);
    await matchRef.set({
      'userId': match.userId,
      'court': match.court,
      'date': Timestamp.fromDate(match.date),
      'setsWon': match.setsWon,
      'setsLost': match.setsLost,
      'status': match.status.toString().split('.').last,
    });
  }

  Future<void> removeMatch(String matchId) async {
    await _firestore.collection('matches').doc(matchId).delete();
  }

  Future<void> updateMatch(String matchId, Map<String, dynamic> updates) async {
    await _firestore
        .collection('matches')
        .doc(matchId)
        .set(updates, SetOptions(merge: true));
  }
}
