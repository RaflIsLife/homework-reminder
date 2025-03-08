// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryDatabaseAdapter extends TypeAdapter<HistoryDatabase> {
  @override
  final int typeId = 3;

  @override
  HistoryDatabase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryDatabase(
      judul: fields[0] as String,
      kategori: fields[2] as String,
      dateTimeList: (fields[3] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, HistoryDatabase obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.judul)
      ..writeByte(2)
      ..write(obj.kategori)
      ..writeByte(3)
      ..write(obj.dateTimeList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryDatabaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
