const String firebaseUrl =
    'squashy-52632-default-rtdb.europe-west1.firebasedatabase.app';
// 'flutter-prep-b9ae8-default-rtdb.europe-west1.firebasedatabase.app';

final Uri leagueMatchesUrl = Uri.https(firebaseUrl, 'league-matches.json');

Uri matchByIdUrl(String id) {
  return Uri.https(firebaseUrl, 'league-matches/$id.json');
}
