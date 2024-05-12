import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nakama_ui/models/session_data.dart';
import 'package:nakama_ui/service/hive_session_service.dart';

class NakamaSessionDataProvider extends AsyncNotifier<SessionData?> {
  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<SessionData?> build() {
    final session = _hiveSessionService.getSession();

    if (session == null) {
      return null;
    }

    final res = JwtDecoder.decode(session.token);

    return SessionData(
      uid: res['uid'],
      email: res['vrs']['email'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(res['exp'] * 1000),
    );
  }
}
