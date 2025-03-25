import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:squashy/models/match.dart';
import 'package:squashy/repositories/match_repository.dart';

part 'match_provider.g.dart';

@riverpod
MatchRepository matchRepository(Ref ref) => MatchRepository();

@riverpod
class MatchNotifier extends _$MatchNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> addMatch(Match match) async {
    state = const AsyncLoading();
    try {
      await ref.read(matchRepositoryProvider).addMatch(match);
      state = const AsyncData(null);
    } catch (error) {
      throw Exception(
          'Something went wrong during match addition: ${error.toString()}');
    }
  }

  Future<void> removeMatch(String matchId) async {
    state = const AsyncLoading();
    try {
      await ref.read(matchRepositoryProvider).removeMatch(matchId);
      state = const AsyncData(null);
    } catch (error) {
      throw Exception(
          'Something went wrong during match removal: ${error.toString()}');
    }
  }

  Future<void> resolveMatch(String matchId) async {
    state = const AsyncLoading();
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Failed to update match - user is not logged in!');
      }

      await ref.read(matchRepositoryProvider).updateMatch(matchId, {
        'userId': user.uid,
        'status': MatchStatus.resolved.toString().split('.').last,
      });
      state = const AsyncData(null);
    } catch (error) {
      throw Exception(
          'Something went wrong during match updating: ${error.toString()}');
    }
  }

  Future<void> replaceMatch(Match match) async {
    state = const AsyncLoading();
    try {
      await ref.read(matchRepositoryProvider).replaceMatch(match);
      state = const AsyncData(null);
    } catch (error) {
      throw Exception(
          'Something went wrong during match replacing: ${error.toString()}');
    }
  }
}

@riverpod
Stream<List<Match>> matchStream(Ref ref) {
  return ref.watch(matchRepositoryProvider).watchMatches();
}
