import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_tag.freezed.dart';
part 'date_tag.g.dart';

@freezed
abstract class DateTag with _$DateTag {
  factory DateTag({
    required String id,
    required String name,
    required String colorValue,
  }) = _DateTag;

  factory DateTag.fromJson(Map<String, dynamic> json) =>
      _$DateTagFromJson(json);
}
