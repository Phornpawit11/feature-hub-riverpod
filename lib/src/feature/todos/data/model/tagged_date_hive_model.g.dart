// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tagged_date_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaggedDateHiveModelAdapter extends TypeAdapter<TaggedDateHiveModel> {
  @override
  final typeId = 2;

  @override
  TaggedDateHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaggedDateHiveModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      tagId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaggedDateHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.tagId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaggedDateHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
