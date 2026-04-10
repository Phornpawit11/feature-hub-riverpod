// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Todo _$TodoFromJson(Map<String, dynamic> json) => _Todo(
  id: json['id'] as String,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isCompleted: json['isCompleted'] as bool,
  priority:
      $enumDecodeNullable(_$TodoPriorityEnumMap, json['priority']) ??
      TodoPriority.low,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  colorValue: json['colorValue'] as String?,
);

Map<String, dynamic> _$TodoToJson(_Todo instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'createdAt': instance.createdAt.toIso8601String(),
  'isCompleted': instance.isCompleted,
  'priority': _$TodoPriorityEnumMap[instance.priority]!,
  'dueDate': instance.dueDate?.toIso8601String(),
  'colorValue': instance.colorValue,
};

const _$TodoPriorityEnumMap = {
  TodoPriority.low: 'low',
  TodoPriority.medium: 'medium',
  TodoPriority.high: 'high',
};
