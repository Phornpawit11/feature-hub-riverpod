import 'package:freezed_annotation/freezed_annotation.dart';

part 'tagged_date.freezed.dart';
part 'tagged_date.g.dart';

@freezed
abstract class TaggedDate with _$TaggedDate {
  factory TaggedDate({
    required String id,
    required DateTime date,
    required String tagId,
  }) = _TaggedDate;

  factory TaggedDate.fromJson(Map<String, dynamic> json) =>
      _$TaggedDateFromJson(json);
}
