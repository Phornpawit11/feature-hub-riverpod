import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/todo_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/todo_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/data/repository/todo_repository_impl.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';

void main() {
  group('TodoRepositoryImpl', () {
    late _FakeTodoLocalDatasource fakeDatasource;
    late ProviderContainer container;

    setUp(() {
      fakeDatasource = _FakeTodoLocalDatasource(
        initialTodos: [
          TodoHiveModel(
            id: '1',
            title: 'Existing task',
            createdAt: DateTime(2026, 1, 1),
            isCompleted: false,
            priorityKey: 'low',
            dueDate: DateTime(2026, 1, 3),
            colorValue: 'FF5B8DEF',
          ),
        ],
      );

      container = ProviderContainer(
        overrides: [
          todoLocalDatasourceProvider.overrideWith(() => fakeDatasource),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('getTodos maps datasource models to domain entities', () async {
      final repository = container.read(todoRepositoryImplProvider.notifier);

      final todos = await repository.getTodos();

      expect(todos, hasLength(1));
      expect(todos.single.title, 'Existing task');
      expect(todos.single.priority, TodoPriority.low);
      expect(todos.single.dueDate, DateTime(2026, 1, 3));
      expect(todos.single.colorValue, 'FF5B8DEF');
    });

    test('addTodo stores a mapped hive model', () async {
      final repository = container.read(todoRepositoryImplProvider.notifier);
      final todo = Todo(
        id: '2',
        title: 'New task',
        createdAt: DateTime(2026, 1, 2),
        isCompleted: false,
        priority: TodoPriority.high,
        dueDate: DateTime(2026, 1, 4),
        colorValue: 'FFEF5350',
      );

      await repository.addTodo(todo);

      expect(fakeDatasource.putTodos, hasLength(1));
      expect(fakeDatasource.putTodos.single.id, '2');
      expect(fakeDatasource.putTodos.single.priorityKey, 'high');
      expect(fakeDatasource.putTodos.single.dueDate, DateTime(2026, 1, 4));
      expect(fakeDatasource.putTodos.single.colorValue, 'FFEF5350');
    });

    test('editTodo updates title and keeps immutable metadata', () async {
      final repository = container.read(todoRepositoryImplProvider.notifier);

      await repository.editTodo(
        '1',
        title: 'Updated task',
        priority: TodoPriority.medium,
        dueDate: DateTime(2026, 1, 6),
        colorValue: 'FF26A69A',
      );

      final updated = fakeDatasource.storedTodos['1'];

      expect(updated, isNotNull);
      expect(updated!.title, 'Updated task');
      expect(updated.createdAt, DateTime(2026, 1, 1));
      expect(updated.isCompleted, isFalse);
      expect(updated.priorityKey, 'medium');
      expect(updated.dueDate, DateTime(2026, 1, 6));
      expect(updated.colorValue, 'FF26A69A');
    });

    test('toggleTodo flips completion and preserves metadata', () async {
      final repository = container.read(todoRepositoryImplProvider.notifier);

      await repository.toggleTodo('1');

      final updated = fakeDatasource.storedTodos['1'];

      expect(updated, isNotNull);
      expect(updated!.isCompleted, isTrue);
      expect(updated.title, 'Existing task');
      expect(updated.priorityKey, 'low');
      expect(updated.dueDate, DateTime(2026, 1, 3));
      expect(updated.colorValue, 'FF5B8DEF');
    });

    test('deleteTodo forwards delete to datasource', () async {
      final repository = container.read(todoRepositoryImplProvider.notifier);

      await repository.deleteTodo('1');

      expect(fakeDatasource.deletedTodoIds, ['1']);
      expect(fakeDatasource.storedTodos.containsKey('1'), isFalse);
    });
  });
}

class _FakeTodoLocalDatasource extends TodoLocalDatasource {
  _FakeTodoLocalDatasource({List<TodoHiveModel>? initialTodos})
    : _initialTodos = initialTodos ?? const [];

  final List<TodoHiveModel> _initialTodos;
  final Map<String, TodoHiveModel> storedTodos = {};
  final List<TodoHiveModel> putTodos = [];
  final List<String> deletedTodoIds = [];

  @override
  FutureOr<void> build() {
    for (final todo in _initialTodos) {
      storedTodos[todo.id] = todo;
    }
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    storedTodos.remove(todoId);
    deletedTodoIds.add(todoId);
  }

  @override
  Future<TodoHiveModel?> getTodoById(String todoId) async {
    return storedTodos[todoId];
  }

  @override
  Future<List<TodoHiveModel>> getTodos() async {
    return storedTodos.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> putTodo(TodoHiveModel todo) async {
    storedTodos[todo.id] = todo;
    putTodos.add(todo);
  }
}
