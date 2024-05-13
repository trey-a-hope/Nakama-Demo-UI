import 'package:hive/hive.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama_ui/data/constants/globals.dart';
import 'package:nakama_ui/domain/models/session_hive_model.dart';
import 'package:path_provider/path_provider.dart';

/// Handles persisting session data.
class HiveSessionService {
  /// Hive box name.
  static const _boxName = 'session';

  /// Hive box instance.
  final _box = Hive.box(_boxName);

  /// Intialized Hive and opens the session box.
  static Future init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(SessionHiveModelAdapter());
    await Hive.openBox(_boxName);
  }

  /// Determines if a session is active.
  /// Returns a session if active, otherwise returns null.
  Future<Session?> sessionActive() async {
    // Check cache for existing session.
    final sessionHive = _box.get(_boxName);

    if (sessionHive == null) {
      return null;
    }

    var session = convertHiveToSession(sessionHive);

    // Check whether a session has expired or is close to expiry.
    if (session.isExpired || session.hasExpired(Globals.inOneHour)) {
      try {
        // Attempt to refresh the existing session.
        session = await getNakamaClient().sessionRefresh(session: session);

        // Update cached session with the refreshed session.
        putSession(session: session);
      } catch (e) {
        // Couldn't refresh the session so reauthenticate.
        return null;
      }
    }

    return session;
  }

  /// Puts a session into the cache.
  void putSession({required Session session}) {
    _box.put(_boxName, convertSessionToHive(session));
  }

  /// Clears the session cache.
  Future clearSession() async => await _box.clear();

  /// Converts cache session data to a Nakama session.
  static Session convertHiveToSession(SessionHiveModel session) => Session(
        token: session.token,
        refreshToken: session.refreshToken,
        created: session.created,
        vars: session.vars,
        userId: session.userId,
        expiresAt: session.expiresAt,
        refreshExpiresAt: session.refreshExpiresAt,
      );

  /// Converts Nakama session to cache session data.
  static SessionHiveModel convertSessionToHive(Session session) =>
      SessionHiveModel(
        token: session.token,
        refreshToken: session.refreshToken,
        created: session.created,
        vars: session.vars,
        userId: session.userId,
        expiresAt: session.expiresAt,
        refreshExpiresAt: session.refreshExpiresAt,
      );
}
