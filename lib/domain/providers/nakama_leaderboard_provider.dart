import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama_ui/data/service/hive_session_service.dart';

class NakamaLeaderboardProvider extends AsyncNotifier<List<LeaderboardRecord>> {
  /// Leaderboard name.
  static const _leaderboardName = 'weekly_leaderboard';

  /// HiveSessionService instance.
  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<List<LeaderboardRecord>> build() async {
    final session = await _hiveSessionService.sessionActive();

    if (session == null) {
      return [];
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
    final session = await _hiveSessionService.sessionActive();

    if (session == null) {
      debugPrint('Session is null, can\'t write record.');
      return;
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
