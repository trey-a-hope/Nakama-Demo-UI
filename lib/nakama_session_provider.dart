import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nakama/nakama.dart';
import 'package:shared_preferences/shared_preferences.dart';

const sessionToken = 'sessionToken';

/// Data class to hold session data.
class SessionData {
  final String uid;
  final String username;
  final DateTime exp;

  SessionData({
    required this.uid,
    required this.username,
    required this.exp,
  });
}

class NakamaSessionProvider extends AsyncNotifier<bool> {
  /// The shared shared instance.
  late SharedPreferences _prefs;

  @override
  FutureOr<bool> build() async {
    // Initialize Nakama client.
    getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      httpPort: 7350,
    );

    // Set shared shared instance.
    _prefs = await SharedPreferences.getInstance();

    // Fetch session token from local storage.
    final token = _prefs.getString(sessionToken);

    // If token is null or expired, return false.
    if (token == null || JwtDecoder.isExpired(token)) {
      return false;
    }

    return true;
  }

  Future authenticateEmail({
    required String email,
    required String password,
  }) async {
    // Authenticate with email and password.
    Session session = await getNakamaClient().authenticateEmail(
      email: email,
      password: password,
      username: email,
      create: true,
    );

    // Save session token to local storage.
    await _prefs.setString(sessionToken, session.token);
    debugPrint('Nakama UID: ${session.userId}');

    // Set authenticated state to true.
    state = const AsyncData(true);
  }

  SessionData? getSessionData() {
    // Fetch session token from local storage.
    final token = _prefs.getString(sessionToken);

    // If token is null, return null.
    if (token == null) {
      return null;
    }

    // Decode token and return session data.
    final res = JwtDecoder.decode(token);

    return SessionData(
      uid: res['uid'],
      username: res['usn'],
      exp: JwtDecoder.getExpirationDate(token),
    );
  }
}
