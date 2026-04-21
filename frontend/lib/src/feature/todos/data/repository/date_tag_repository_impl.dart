import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/date_tag_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/date_tag_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/tagged_date_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag_repository.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';

part 'date_tag_repository_impl.g.dart';

@riverpod
class DateTagRepositoryImpl extends _$DateTagRepositoryImpl
    implements DateTagRepository {
  DateTagLocalDatasource get _datasource =>
      ref.watch(dateTagLocalDatasourceProvider.notifier);

  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  @override
  Future<void> assignTagToDate(DateTime date, String tagId) async {
    final normalizedDate = normalizeDate(date);
    await _datasource.putTaggedDate(
      TaggedDateHiveModel.fromDomain(
        TaggedDate(
          id: dateStorageKey(normalizedDate),
          date: normalizedDate,
          tagId: tagId,
        ),
      ),
    );
  }

  @override
  Future<void> createTag(DateTag tag) async {
    await _datasource.putDateTag(DateTagHiveModel.fromDomain(tag));
  }

  @override
  Future<void> deleteTag(String tagId) async {
    await _datasource.deleteDateTag(tagId);
    await _datasource.deleteTaggedDatesByTagId(tagId);
  }

  @override
  Future<List<DateTag>> getDateTags() async {
    final tags = await _datasource.getDateTags();
    return tags.map((tag) => tag.toDomain()).toList();
  }

  @override
  Future<List<TaggedDate>> getTaggedDates() async {
    final taggedDates = await _datasource.getTaggedDates();
    return taggedDates.map((taggedDate) => taggedDate.toDomain()).toList();
  }

  @override
  Future<void> removeTagFromDate(DateTime date) async {
    await _datasource.deleteTaggedDateByDate(date);
  }

  @override
  Future<void> updateTag(DateTag tag) async {
    await _datasource.putDateTag(DateTagHiveModel.fromDomain(tag));
  }
}
