// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pengingat_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PengingatDatabaseAdapter extends TypeAdapter<PengingatDatabase> {
  @override
  final int typeId = 1;

  @override
  PengingatDatabase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PengingatDatabase(
      judul: fields[0] as String,
      kategori: fields[1] as String,
      dateTimeList: (fields[2] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, PengingatDatabase obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.judul)
      ..writeByte(1)
      ..write(obj.kategori)
      ..writeByte(2)
      ..write(obj.dateTimeList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PengingatDatabaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
