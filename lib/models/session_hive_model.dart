import 'package:hive/hive.dart';

part 'session_hive_model.g.dart';

@HiveType(typeId: 0)
class SessionHiveModel extends HiveObject {
  @HiveField(0)
  String token;

  @HiveField(1)
  String? refreshToken;

  @HiveField(2)
  bool created;

  @HiveField(3)
  Map<String, String>? vars;

  @HiveField(4)
  String userId;

  @HiveField(5)
  DateTime expiresAt;

  @HiveField(6)
  DateTime refreshExpiresAt;

  SessionHiveModel({
    required this.token,
    this.refreshToken,
    required this.created,
    this.vars,
    required this.userId,
    required this.expiresAt,
    required this.refreshExpiresAt,
  });
}

//flutter packages pub run build_runner build 