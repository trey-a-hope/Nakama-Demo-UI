import 'package:hive/hive.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama_ui/models/session_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveSessionService {
  static const _boxName = 'session';

  final _box = Hive.box(_boxName);

  static Future init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(SessionHiveModelAdapter());
    await Hive.openBox(_boxName);
  }

  void putSession({required Session session}) {
    _box.put(_boxName, convertSessionToHive(session));
  }

  Session? getSession() {
    final sessionHive = _box.get(_boxName);

    if (sessionHive == null) {
      return null;
    }

    return convertHiveToSession(sessionHive);
  }

  void clearSession() => _box.clear();

  static Session convertHiveToSession(SessionHiveModel session) => Session(
        token: session.token,
        refreshToken: session.refreshToken,
        created: session.created,
        vars: session.vars,
        userId: session.userId,
        expiresAt: session.expiresAt,
        refreshExpiresAt: session.refreshExpiresAt,
      );

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
