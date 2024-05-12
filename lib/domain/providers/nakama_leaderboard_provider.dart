import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama_ui/data/constants/globals.dart';
import 'package:nakama_ui/data/service/hive_session_service.dart';

class NakamaLeaderboardProvider extends AsyncNotifier<List<LeaderboardRecord>> {
  static const _leaderboardName = 'weekly_leaderboard';

  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<List<LeaderboardRecord>> build() async {
    var session = _hiveSessionService.getSession();

    if (session == null) {
      throw Exception('Session is null.');
    }

    // Check whether a session has expired or is close to expiry.
    if (session.isExpired || session.hasExpired(Globals.inOneHour)) {
      try {
        // Attempt to refresh the existing session.
        session = await getNakamaClient().sessionRefresh(session: session);

        // Update cached session with the refreshed session.
        _hiveSessionService.putSession(session: session);
      } catch (e) {
        // Couldn't refresh the session so return empty list of results.
        return [];
      }
    }

    // Get leaderboard records.
    LeaderboardRecordList leaderboardRecordList =
        await getNakamaClient().listLeaderboardRecords(
      session: session,
      leaderboardName: _leaderboardName,
    );

    List<LeaderboardRecord> leaderboardRecords = leaderboardRecordList.records;

    return leaderboardRecords;
  }

  Future writeLeaderboardRecord({required int score}) async {
    var session = _hiveSessionService.getSession();

    if (session == null) {
      throw Exception('Session is null.');
    }

    // Check whether a session has expired or is close to expiry.
    if (session.isExpired || session.hasExpired(Globals.inOneHour)) {
      try {
        // Attempt to refresh the existing session.
        session = await getNakamaClient().sessionRefresh(session: session);

        // Update cached session with the refreshed session.
        _hiveSessionService.putSession(session: session);
      } catch (e) {
        throw Exception('Could not submit record at this time.');
      }

      debugPrint('Potential score of $score set for ${session.userId}');

      await getNakamaClient().writeLeaderboardRecord(
        session: session,
        leaderboardName: _leaderboardName,
        score: score,
      );

      // Get leaderboard records.
      final leaderboardRecordList =
          await getNakamaClient().listLeaderboardRecords(
        session: session,
        leaderboardName: _leaderboardName,
      );

      final leaderboardRecords = leaderboardRecordList.records;

      state = AsyncData(leaderboardRecords);
    }
  }
}
