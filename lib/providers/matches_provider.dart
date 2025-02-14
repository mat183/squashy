import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:squashy/models/match.dart';
import 'package:squashy/utils/firebase.dart';

part 'matches_provider.g.dart';

@riverpod
class MatchesNotifier extends _$MatchesNotifier {
  @override
  FutureOr<List<Match>> build() async {
    return await _fetchMatches();
  }

  // HTTP GET
  Future<List<Match>> _fetchMatches() async {
    try {
      final response = await http.get(leagueMatchesUrl);

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch matches.');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>?;

      if (response.body == 'null' || data == null) {
        return [];
      }

      return data.entries
          .map((entry) => Match(
                id: entry.key,
                court: entry.value['court'],
                date: DateTime.parse(entry.value['date']),
                status: MatchStatus.values.byName(entry.value['status']),
              ))
          .toList();
    } catch (error) {
      throw Exception(
          'Something went wrong during matches fetching: ${error.toString()}');
    }
  }

  Future<void> addMatch(Match match) async {
    try {
      final response = await http.post(
        leagueMatchesUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'court': match.court,
            'date': match.date.toString(),
            'status': match.status.toString().split('.').last,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add match.');
      }

      final newMatchId = jsonDecode(response.body)['name'];
      final newMatch = Match(
        id: newMatchId,
        court: match.court,
        date: match.date,
        status: match.status,
      );
      state = AsyncValue.data([...state.value ?? [], newMatch]);
    } catch (error) {
      throw Exception(
          'Something went wrong during match addition: ${error.toString()}');
    }
  }

  Future<void> removeMatch(Match match) async {
    try {
      final response = await http.delete(matchByIdUrl(match.id));

      if (response.statusCode != 200) {
        throw Exception('Failed to remove match.');
      }

      state =
          AsyncValue.data(state.value!.where((m) => m.id != match.id).toList());
    } catch (error) {
      throw Exception(
          'Something went wrong during match removal: ${error.toString()}');
    }
  }

  Future<void> updateMatch(Match match, MatchStatus status) async {
    try {
      final response = await http.patch(
        matchByIdUrl(match.id),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            'status': status.toString().split('.').last,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update match.');
      }

      state = AsyncValue.data(state.value!
          .map((m) => m.id == match.id
              ? Match(
                  id: match.id,
                  court: match.court,
                  date: match.date,
                  status: status,
                )
              : m)
          .toList());
    } catch (error) {
      throw Exception(
          'Something went wrong during match updating: ${error.toString()}');
    }
  }

  Future<void> replaceMatch(Match match) async {
    try {
      final response = await http.put(
        matchByIdUrl(match.id),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'court': match.court,
            'date': match.date.toString(),
            'status': match.status.toString().split('.').last,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to replace match.');
      }

      state = AsyncValue.data(
          state.value!.map((m) => m.id == match.id ? match : m).toList());
    } catch (error) {
      throw Exception(
          'Something went wrong during match replacing: ${error.toString()}');
    }
  }
}
