import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squashy/models/match.dart';

class MatchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Match>> watchMatches() {
    return _firestore
        .collection('matches')
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Match(
                id: doc.id,
                userId: doc.get('userId'),
                court: doc.get('court'),
                date: doc.get('date').toDate(),
                status: MatchStatus.values.byName(doc.get('status'))))
            .toList());
  }

  Future<void> addMatch(Match match) async {
    final matchRef = _firestore.collection('matches').doc(match.id);
    await matchRef.set({
      'userId': match.userId,
      'court': match.court,
      'date': Timestamp.fromDate(match.date),
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
      'date': Timestamp.fromDate(match.date),
      'status': match.status.toString().split('.').last,
    });
  }
}
