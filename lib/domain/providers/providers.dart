import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama_ui/domain/models/session_data.dart';
import 'package:nakama_ui/domain/providers/nakama_leaderboard_provider.dart';
import 'package:nakama_ui/domain/providers/nakama_authenticated_provider.dart';
import 'package:nakama_ui/domain/providers/nakama_session_data_provider.dart';

class Providers {
  static final nakamaAuthenticatedProvider =
      AsyncNotifierProvider<NakamaAuthenticatedProvider, bool>(
          NakamaAuthenticatedProvider.new);

  static final nakamaLeaderboardProvider =
      AsyncNotifierProvider<NakamaLeaderboardProvider, List<LeaderboardRecord>>(
          NakamaLeaderboardProvider.new);

  static final nakamaSessionDataProvider =
      AsyncNotifierProvider<NakamaSessionDataProvider, SessionData?>(
          NakamaSessionDataProvider.new);
}
