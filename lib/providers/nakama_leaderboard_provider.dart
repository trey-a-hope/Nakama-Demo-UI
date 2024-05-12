import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama/nakama.dart';

class NakamaLeaderboardProvider extends AsyncNotifier<List<LeaderboardRecord>> {
  final String _leaderboardId = 'weekly_leaderboard';

  /// The shared shared instance.
  // late SharedPreferences _prefs;

  @override
  FutureOr<List<LeaderboardRecord>> build() async {
    return [];
    // // Set shared shared instance.
    // _prefs = await SharedPreferences.getInstance();

    // // Fetch session token from local storage.
    // final token = _prefs.getString(sessionToken);

    // // If token is null or expired, return false.
    // if (token == null || JwtDecoder.isExpired(token)) {
    //   throw Exception('Session token is null or expired.');
    // }

    // var s = JwtDecoder.decode(token);

    // // Build session object.
    // final session = ns.Session(
    //   token: token,
    //   created: true,
    //   refreshExpiresAt: DateTime.now(),
    //   refreshToken: '',
    //   vars: null,
    //   userId: s['uid'],
    //   expiresAt: DateTime.fromMillisecondsSinceEpoch(s['exp'] * 1000),
    // );

    // // Get leaderboard records.
    // LeaderboardRecordList leaderboardRecordList =
    //     await getNakamaClient().listLeaderboardRecords(
    //   session: session,
    //   leaderboardName: _leaderboardId,
    // );

    // List<LeaderboardRecord> leaderboardRecords = leaderboardRecordList.records;

    // return leaderboardRecords;
  }

  Future writeLeaderboardRecord({required int score}) async {
    // // Set shared shared instance.
    // _prefs = await SharedPreferences.getInstance();

    // // Fetch session token from local storage.
    // var token = _prefs.getString(sessionToken);

    // // If token is null or expired, return false.
    // if (token == null || JwtDecoder.isExpired(token)) {
    //   // Attempt to refresh token.
    //   token = _prefs.getString(sessionRefreshToken);
    // }

    // if (token == null) {
    //   throw Exception('Session token is null or expired.');
    // }

    // // getNakamaClient().

    // // Build session object.
    // final session = ns.Session(
    //   token: token,
    //   created: true,
    //   refreshExpiresAt: DateTime.now(),
    //   refreshToken: '',
    //   vars: null,
    //   userId: '',
    //   expiresAt: DateTime.now(),
    // );

    // getNakamaClient().writeLeaderboardRecord(
    //   session: session,
    //   leaderboardName: _leaderboardId,
    //   score: score,
    // );
  }
}
