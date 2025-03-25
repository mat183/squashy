import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squashy/models/result.dart';

class ResultRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Result>> watchResults() {
    return _firestore
        .collection('results')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => Result(
                id: doc.id,
                matchId: doc.get('matchId'),
                userId: doc.get('userId'),
                setsWon: doc.get('setsWon'),
                setsLost: doc.get('setsLost'),
                verdict: MatchVerdict.values.byName(doc.get('verdict')),
              ),
            )
            .toList());
  }

  Future<void> addResult(Result result) async {
    final resultRef = _firestore.collection('results').doc(result.id);
    await resultRef.set({
      'matchId': result.matchId,
      'userId': result.userId,
      'setsWon': result.setsWon,
      'setsLost': result.setsLost,
      'verdict': result.verdict.toString().split('.').last,
    });
  }

  Future<void> removeResult(String resultId) async {
    await _firestore.collection('results').doc(resultId).delete();
  }
}
