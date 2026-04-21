import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/date_tag_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/date_tag_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/tagged_date_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/repository/date_tag_repository_impl.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';

void main() {
  group('DateTagRepositoryImpl', () {
    late _FakeDateTagLocalDatasource fakeDatasource;
    late ProviderContainer container;

    setUp(() {
      fakeDatasource = _FakeDateTagLocalDatasource(
        tags: [
          DateTagHiveModel(id: 'work', name: 'Work', colorValue: 'FF5B8DEF'),
        ],
        taggedDates: [
          TaggedDateHiveModel(
            id: '2026-04-10',
            date: DateTime(2026, 4, 10),
            tagId: 'work',
          ),
        ],
      );

      container = ProviderContainer(
        overrides: [
          dateTagLocalDatasourceProvider.overrideWith(() => fakeDatasource),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('getDateTags maps hive models to domain entities', () async {
      final repository = container.read(dateTagRepositoryImplProvider.notifier);

      final tags = await repository.getDateTags();

      expect(tags, hasLength(1));
      expect(tags.single.name, 'Work');
      expect(tags.single.colorValue, 'FF5B8DEF');
    });

    test('assignTagToDate normalizes date and stores tagged date', () async {
      final repository = container.read(dateTagRepositoryImplProvider.notifier);

      await repository.assignTagToDate(DateTime(2026, 4, 12, 22, 15), 'work');

      expect(fakeDatasource.taggedDatesById['2026-04-12'], isNotNull);
      expect(
        fakeDatasource.taggedDatesById['2026-04-12']!.date,
        DateTime(2026, 4, 12),
      );
    });

    test('deleteTag cascades tagged date cleanup', () async {
      final repository = container.read(dateTagRepositoryImplProvider.notifier);

      await repository.deleteTag('work');

      expect(fakeDatasource.tagsById.containsKey('work'), isFalse);
      expect(fakeDatasource.taggedDatesById, isEmpty);
    });

    test('removeTagFromDate deletes by normalized date key', () async {
      final repository = container.read(dateTagRepositoryImplProvider.notifier);

      await repository.removeTagFromDate(DateTime(2026, 4, 10, 8, 30));

      expect(fakeDatasource.taggedDatesById.containsKey('2026-04-10'), isFalse);
    });

    test('updateTag persists latest name and color', () async {
      final repository = container.read(dateTagRepositoryImplProvider.notifier);

      await repository.updateTag(
        DateTag(id: 'work', name: 'Deep Work', colorValue: 'FF26A69A'),
      );

      expect(fakeDatasource.tagsById['work']!.name, 'Deep Work');
      expect(fakeDatasource.tagsById['work']!.colorValue, 'FF26A69A');
    });
  });
}

class _FakeDateTagLocalDatasource extends DateTagLocalDatasource {
  _FakeDateTagLocalDatasource({
    List<DateTagHiveModel>? tags,
    List<TaggedDateHiveModel>? taggedDates,
  }) : _initialTags = tags ?? const [],
       _initialTaggedDates = taggedDates ?? const [];

  final List<DateTagHiveModel> _initialTags;
  final List<TaggedDateHiveModel> _initialTaggedDates;

  final Map<String, DateTagHiveModel> tagsById = {};
  final Map<String, TaggedDateHiveModel> taggedDatesById = {};

  @override
  FutureOr<void> build() {
    for (final tag in _initialTags) {
      tagsById[tag.id] = tag;
    }

    for (final taggedDate in _initialTaggedDates) {
      taggedDatesById[taggedDate.id] = taggedDate;
    }
  }

  @override
  Future<void> deleteDateTag(String tagId) async {
    tagsById.remove(tagId);
  }

  @override
  Future<void> deleteTaggedDateByDate(DateTime date) async {
    taggedDatesById.remove(dateStorageKey(date));
  }

  @override
  Future<void> deleteTaggedDatesByTagId(String tagId) async {
    taggedDatesById.removeWhere((_, taggedDate) => taggedDate.tagId == tagId);
  }

  @override
  Future<List<DateTagHiveModel>> getDateTags() async {
    return tagsById.values.toList();
  }

  @override
  Future<List<TaggedDateHiveModel>> getTaggedDates() async {
    return taggedDatesById.values.toList();
  }

  @override
  Future<void> putDateTag(DateTagHiveModel tag) async {
    tagsById[tag.id] = tag;
  }

  @override
  Future<void> putTaggedDate(TaggedDateHiveModel taggedDate) async {
    taggedDatesById[taggedDate.id] = taggedDate;
  }
}
