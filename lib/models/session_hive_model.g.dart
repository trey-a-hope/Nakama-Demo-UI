// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionHiveModelAdapter extends TypeAdapter<SessionHiveModel> {
  @override
  final int typeId = 0;

  @override
  SessionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionHiveModel(
      token: fields[0] as String,
      refreshToken: fields[1] as String?,
      created: fields[2] as bool,
      vars: (fields[3] as Map?)?.cast<String, String>(),
      userId: fields[4] as String,
      expiresAt: fields[5] as DateTime,
      refreshExpiresAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SessionHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.refreshToken)
      ..writeByte(2)
      ..write(obj.created)
      ..writeByte(3)
      ..write(obj.vars)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.expiresAt)
      ..writeByte(6)
      ..write(obj.refreshExpiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
