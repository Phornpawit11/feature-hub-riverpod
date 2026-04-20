// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tagged_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaggedDate _$TaggedDateFromJson(Map<String, dynamic> json) => _TaggedDate(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  tagId: json['tagId'] as String,
);

Map<String, dynamic> _$TaggedDateToJson(_TaggedDate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'tagId': instance.tagId,
    };
