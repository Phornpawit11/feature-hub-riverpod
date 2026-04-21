import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/core/storage/hive_boxes.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/date_tag_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/date_tag_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/tagged_date_hive_model.dart';

void main() {
  late Directory tempDirectory;

  setUpAll(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'todos_riverpod_date_tag_datasource_test',
    );
    Hive.init(tempDirectory.path);

    if (!Hive.isAdapterRegistered(DateTagHiveModelAdapter().typeId)) {
      Hive.registerAdapter(DateTagHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(TaggedDateHiveModelAdapter().typeId)) {
      Hive.registerAdapter(TaggedDateHiveModelAdapter());
    }
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveBoxes.dateTags)) {
      await Hive.box<DateTagHiveModel>(HiveBoxes.dateTags).clear();
    } else {
      await Hive.openBox<DateTagHiveModel>(HiveBoxes.dateTags);
    }

    if (Hive.isBoxOpen(HiveBoxes.taggedDates)) {
      await Hive.box<TaggedDateHiveModel>(HiveBoxes.taggedDates).clear();
    } else {
      await Hive.openBox<TaggedDateHiveModel>(HiveBoxes.taggedDates);
    }
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen(HiveBoxes.dateTags)) {
      await Hive.box<DateTagHiveModel>(HiveBoxes.dateTags).clear();
    }
    if (Hive.isBoxOpen(HiveBoxes.taggedDates)) {
      await Hive.box<TaggedDateHiveModel>(HiveBoxes.taggedDates).clear();
    }
    await Hive.close();
    await tempDirectory.delete(recursive: true);
  });

  group('DateTagLocalDatasource', () {
    test('persists date tags', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(
        dateTagLocalDatasourceProvider.notifier,
      );

      await datasource.putDateTag(
        DateTagHiveModel(id: 'work', name: 'Work', colorValue: 'FF5B8DEF'),
      );

      final tags = await datasource.getDateTags();
      expect(tags.single.name, 'Work');
      expect(tags.single.colorValue, 'FF5B8DEF');
    });

    test('persists tagged dates and normal date key lookups', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(
        dateTagLocalDatasourceProvider.notifier,
      );

      await datasource.putTaggedDate(
        TaggedDateHiveModel(
          id: '2026-04-10',
          date: DateTime(2026, 4, 10),
          tagId: 'work',
        ),
      );

      final taggedDate = await datasource.getTaggedDateByDate(
        DateTime(2026, 4, 10, 18, 45),
      );

      expect(taggedDate, isNotNull);
      expect(taggedDate!.tagId, 'work');
      expect(taggedDate.id, '2026-04-10');
    });

    test('deleteTaggedDatesByTagId removes all linked assignments', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(
        dateTagLocalDatasourceProvider.notifier,
      );

      await datasource.putTaggedDate(
        TaggedDateHiveModel(
          id: '2026-04-10',
          date: DateTime(2026, 4, 10),
          tagId: 'work',
        ),
      );
      await datasource.putTaggedDate(
        TaggedDateHiveModel(
          id: '2026-04-11',
          date: DateTime(2026, 4, 11),
          tagId: 'work',
        ),
      );

      await datasource.deleteTaggedDatesByTagId('work');

      final taggedDates = await datasource.getTaggedDates();
      expect(taggedDates, isEmpty);
    });
  });
}
