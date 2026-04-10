import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/core/storage/hive_boxes.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/todo_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/todo_hive_model.dart';

void main() {
  late Directory tempDirectory;

  setUpAll(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'todos_riverpod_datasource_test',
    );
    Hive.init(tempDirectory.path);

    if (!Hive.isAdapterRegistered(TodoHiveModelAdapter().typeId)) {
      Hive.registerAdapter(TodoHiveModelAdapter());
    }
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveBoxes.todos)) {
      await Hive.box<TodoHiveModel>(HiveBoxes.todos).clear();
    } else {
      await Hive.openBox<TodoHiveModel>(HiveBoxes.todos);
    }
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen(HiveBoxes.todos)) {
      await Hive.box<TodoHiveModel>(HiveBoxes.todos).clear();
    }
    await Hive.close();
    await tempDirectory.delete(recursive: true);
  });

  group('TodoLocalDatasource', () {
    test('getTodos returns items sorted by createdAt descending', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(todoLocalDatasourceProvider.notifier);

      await datasource.putTodo(
        TodoHiveModel(
          id: 'older',
          title: 'Older',
          createdAt: DateTime(2026, 1, 1),
          isCompleted: false,
        ),
      );
      await datasource.putTodo(
        TodoHiveModel(
          id: 'newer',
          title: 'Newer',
          createdAt: DateTime(2026, 1, 2),
          isCompleted: false,
        ),
      );

      final todos = await datasource.getTodos();

      expect(todos.map((todo) => todo.id), ['newer', 'older']);
    });

    test('putTodo and getTodoById persist metadata fields', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(todoLocalDatasourceProvider.notifier);
      final todo = TodoHiveModel(
        id: '1',
        title: 'Plan sprint',
        createdAt: DateTime(2026, 1, 5),
        isCompleted: false,
        priorityKey: 'high',
        dueDate: DateTime(2026, 1, 10),
        colorValue: 'FF26A69A',
      );

      await datasource.putTodo(todo);
      final stored = await datasource.getTodoById('1');

      expect(stored, isNotNull);
      expect(stored!.title, 'Plan sprint');
      expect(stored.priorityKey, 'high');
      expect(stored.dueDate, DateTime(2026, 1, 10));
      expect(stored.colorValue, 'FF26A69A');
    });

    test('deleteTodo removes an existing item', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final datasource = container.read(todoLocalDatasourceProvider.notifier);

      await datasource.putTodo(
        TodoHiveModel(
          id: '1',
          title: 'Disposable',
          createdAt: DateTime(2026, 1, 1),
          isCompleted: false,
        ),
      );

      await datasource.deleteTodo('1');
      final stored = await datasource.getTodoById('1');

      expect(stored, isNull);
    });
  });
}
