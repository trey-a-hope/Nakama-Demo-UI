import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama_ui/service/hive_session_service.dart';

class NakamaAuthenticatedProvider extends AsyncNotifier<bool> {
  final _hiveSessionService = HiveSessionService();

  final _inOneHour = DateTime.now().add(
    const Duration(
      hours: 1,
    ),
  );

  @override
  FutureOr<bool> build() async {
    // Initialize Nakama client.
    getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
      httpPort: 7350,
    );

    var session = _hiveSessionService.getSession();

    if (session == null) {
      return false;
    }

    // Check whether a session has expired or is close to expiry.
    if (session.isExpired || session.hasExpired(_inOneHour)) {
      try {
        // Attempt to refresh the existing session.
        session = await getNakamaClient().sessionRefresh(session: session);

        // Update cached session with the refreshed session.
        _hiveSessionService.putSession(session: session);
      } catch (e) {
        // Couldn't refresh the session so reauthenticate.
        return false;
      }
    }

    return true;
  }

  Future authenticateEmail({
    required String email,
    required String password,
  }) async {
    // Authenticate with email and password.
    final session = await getNakamaClient().authenticateEmail(
      email: email,
      password: password,
      create: true,
      vars: {
        'email': email,
      },
    );

    // Save session token to local storage.
    _hiveSessionService.putSession(session: session);

    debugPrint('Nakama UID: ${session.userId}');

    // Set authenticated state to true.
    state = const AsyncData(true);
  }

  Future logout() async {
    var session = _hiveSessionService.getSession();

    if (session == null) {
      throw Exception('No session found.');
    }

    /*
      TODO: Currently cannot logout of session via the Nakama Client...
      
      await getNakamaClient().sessionLogout(session: session);

      "GrpcError (gRPC Error (code: 16, codeName: UNAUTHENTICATED, 
      message: Auth token invalid, details: [], rawResponse: null, 
      trailers: {}))"

      For now, just clear the session from local storage.
    */

    _hiveSessionService.clearSession();

    state = const AsyncData(false);
  }
}
