import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';

class NakamaService {
  NakamaService() {
    getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      httpPort: 7350,
    );
  }

  Future<Session> authenticateEmail({
    required String email,
    required String password,
    required String? username,
    required bool create,
  }) async {
    Session session = await getNakamaClient().authenticateEmail(
      email: email,
      password: password,
      username: username,
      create: create,
    );

    debugPrint('Nakama UID: ${session.userId}');

    return session;
  }
}
