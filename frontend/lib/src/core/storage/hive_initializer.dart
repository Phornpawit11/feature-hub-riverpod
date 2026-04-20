import 'package:hive_ce_flutter/adapters.dart';
import 'package:todos_riverpod/src/core/storage/hive_boxes.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/date_tag_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/tagged_date_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/todo_hive_model.dart';

class HiveInitializer {
  const HiveInitializer._();

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(TodoHiveModelAdapter().typeId)) {
      Hive.registerAdapter(TodoHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(DateTagHiveModelAdapter().typeId)) {
      Hive.registerAdapter(DateTagHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(TaggedDateHiveModelAdapter().typeId)) {
      Hive.registerAdapter(TaggedDateHiveModelAdapter());
    }

    if (!Hive.isBoxOpen(HiveBoxes.todos)) {
      await Hive.openBox<TodoHiveModel>(HiveBoxes.todos);
    }
    if (!Hive.isBoxOpen(HiveBoxes.dateTags)) {
      await Hive.openBox<DateTagHiveModel>(HiveBoxes.dateTags);
    }
    if (!Hive.isBoxOpen(HiveBoxes.taggedDates)) {
      await Hive.openBox<TaggedDateHiveModel>(HiveBoxes.taggedDates);
    }
  }
}
