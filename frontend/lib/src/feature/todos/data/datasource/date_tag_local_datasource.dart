import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/core/storage/hive_boxes.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/date_tag_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/tagged_date_hive_model.dart';

part 'date_tag_local_datasource.g.dart';

@riverpod
class DateTagLocalDatasource extends _$DateTagLocalDatasource {
  @override
  FutureOr<void> build() {}

  Future<List<DateTagHiveModel>> getDateTags() async {
    final tags = Hive.box<DateTagHiveModel>(HiveBoxes.dateTags).values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return tags;
  }

  Future<void> putDateTag(DateTagHiveModel tag) async {
    await Hive.box<DateTagHiveModel>(HiveBoxes.dateTags).put(tag.id, tag);
  }

  Future<DateTagHiveModel?> getDateTagById(String tagId) async {
    return Hive.box<DateTagHiveModel>(HiveBoxes.dateTags).get(tagId);
  }

  Future<void> deleteDateTag(String tagId) async {
    await Hive.box<DateTagHiveModel>(HiveBoxes.dateTags).delete(tagId);
  }

  Future<List<TaggedDateHiveModel>> getTaggedDates() async {
    final taggedDates = Hive.box<TaggedDateHiveModel>(
      HiveBoxes.taggedDates,
    ).values.toList()..sort((a, b) => a.date.compareTo(b.date));
    return taggedDates;
  }

  Future<TaggedDateHiveModel?> getTaggedDateByDate(DateTime date) async {
    return Hive.box<TaggedDateHiveModel>(
      HiveBoxes.taggedDates,
    ).get(dateStorageKey(date));
  }

  Future<void> putTaggedDate(TaggedDateHiveModel taggedDate) async {
    await Hive.box<TaggedDateHiveModel>(
      HiveBoxes.taggedDates,
    ).put(dateStorageKey(taggedDate.date), taggedDate);
  }

  Future<void> deleteTaggedDateByDate(DateTime date) async {
    await Hive.box<TaggedDateHiveModel>(
      HiveBoxes.taggedDates,
    ).delete(dateStorageKey(date));
  }

  Future<void> deleteTaggedDatesByTagId(String tagId) async {
    final box = Hive.box<TaggedDateHiveModel>(HiveBoxes.taggedDates);
    final keysToDelete = box.values
        .where((taggedDate) => taggedDate.tagId == tagId)
        .map((taggedDate) => dateStorageKey(taggedDate.date))
        .toList();

    await box.deleteAll(keysToDelete);
  }
}
