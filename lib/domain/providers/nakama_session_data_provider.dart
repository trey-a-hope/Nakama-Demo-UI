import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nakama_ui/domain/models/session_data.dart';
import 'package:nakama_ui/data/service/hive_session_service.dart';
import 'package:nakama_ui/domain/providers/providers.dart';

class NakamaSessionDataProvider extends AsyncNotifier<SessionData?> {
  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<SessionData?> build() {
    ref.watch(Providers.nakamaAuthenticatedProvider);

    final session = _hiveSessionService.getSession();

    if (session == null) {
      return null;
    }

    final res = JwtDecoder.decode(session.token);

    return SessionData(
      uid: res['uid'],
      username: res['usn'],
      email: res['vrs']['email'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(res['exp'] * 1000),
    );
  }
}
