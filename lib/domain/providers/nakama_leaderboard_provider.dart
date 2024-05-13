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
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    // If session is null, return empty list.
    if (session == null) {
      return [];
    }

    // Get leaderboard records.
    final leaderboardRecordList =
        await getNakamaClient().listLeaderboardRecords(
      session: session,
      leaderboardName: _leaderboardName,
    );

    // Return leaderboard records from list.
    return leaderboardRecordList.records;
  }

  /// Write leaderboard record.
  Future writeLeaderboardRecord({required int score}) async {
    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    // If session is null, return.
    if (session == null) {
      debugPrint('Session is null, can\'t write record.');
      return;
    }

    // Write leaderboard record.
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

    // Update state with new records.
    state = AsyncData(leaderboardRecordList.records);
  }
}
