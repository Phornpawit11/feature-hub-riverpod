// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoHiveModelAdapter extends TypeAdapter<TodoHiveModel> {
  @override
  final typeId = 0;

  @override
  TodoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[2] as DateTime,
      isCompleted: fields[3] as bool,
      priorityKey: fields[4] == null ? 'medium' : fields[4] as String,
      dueDate: fields[5] as DateTime?,
      colorValue: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.priorityKey)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
