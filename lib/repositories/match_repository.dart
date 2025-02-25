import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squashy/models/match.dart';

class MatchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Match>> watchMatches() {
    return _firestore.collection('matches').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Match(
                id: doc.id,
                userId: doc.get('userId'),
                court: doc.get('court'),
                date: DateTime.parse(doc.get('date')),
                status: MatchStatus.values.byName(doc.get('status'))))
            .toList());
  }

  Future<List<Match>> fetchMatches() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('matches').get();
    return querySnapshot.docs
        .map((doc) => Match(
            id: doc.id,
            userId: doc.get('userId'),
            court: doc.get('court'),
            date: DateTime.parse(doc.get('date')),
            status: MatchStatus.values.byName(doc.get('status'))))
        .toList();
  }

  Future<void> addMatch(Match match) async {
    final matchRef = _firestore.collection('matches').doc();
    await matchRef.set({
      'userId': match.userId,
      'court': match.court,
      'date': match.date.toString(),
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

  Future<void> replaceMatch(Match match) async {
    final matchRef = _firestore.collection('matches').doc(match.id);
    await matchRef.set({
      'userId': match.userId,
      'court': match.court,
      'date': match.date.toString(),
      'status': match.status.toString().split('.').last,
    });
  }
}
