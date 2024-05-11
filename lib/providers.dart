import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama_ui/nakama_session_provider.dart';

class Providers {
  static final nakamaSessionProvider =
      AsyncNotifierProvider<NakamaSessionProvider, bool>(
          NakamaSessionProvider.new);
}
