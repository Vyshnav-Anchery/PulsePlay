// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlistdatabase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistDatabaseAdapter extends TypeAdapter<PlaylistDatabase> {
  @override
  final int typeId = 1;

  @override
  PlaylistDatabase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistDatabase(
      songUris: (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>())),
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistDatabase obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.songUris);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistDatabaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
