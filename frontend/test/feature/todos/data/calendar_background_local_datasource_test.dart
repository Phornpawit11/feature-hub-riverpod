import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/core/storage/hive_boxes.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/calendar_background_local_datasource.dart';

void main() {
  late Directory tempDirectory;

  setUpAll(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'todos_riverpod_calendar_background_datasource_test',
    );
    Hive.init(tempDirectory.path);
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveBoxes.calendarBackgroundSettings)) {
      await Hive.box<String>(HiveBoxes.calendarBackgroundSettings).clear();
    } else {
      await Hive.openBox<String>(HiveBoxes.calendarBackgroundSettings);
    }
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen(HiveBoxes.calendarBackgroundSettings)) {
      await Hive.box<String>(HiveBoxes.calendarBackgroundSettings).clear();
    }
    await Hive.close();
    await tempDirectory.delete(recursive: true);
  });

  group('CalendarBackgroundLocalDatasource', () {
    test('persists calendar background path', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(
        calendarBackgroundLocalDatasourceProvider,
      );

      await datasource.setCalendarBackground('/tmp/calendar-bg.jpg');

      expect(
        await datasource.loadCalendarBackground(),
        '/tmp/calendar-bg.jpg',
      );
    });

    test('clears persisted calendar background path', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(
        calendarBackgroundLocalDatasourceProvider,
      );

      await datasource.setCalendarBackground('/tmp/calendar-bg.jpg');
      await datasource.clearCalendarBackground();

      expect(await datasource.loadCalendarBackground(), isNull);
    });
  });
}
