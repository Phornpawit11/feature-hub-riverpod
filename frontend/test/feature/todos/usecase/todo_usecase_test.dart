import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/todo_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/todo.usecase.dart';

void main() {
  group('TodoUsecase', () {
    late _FakeTodoRepository fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Write tests',
            createdAt: DateTime(2026),
            isCompleted: false,
            dueDate: DateTime(2026, 1, 3),
            colorValue: 'FF5B8DEF',
          ),
        ],
      );

      container = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(fakeRepository)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('loads initial todos from repository', () async {
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos, hasLength(1));
      expect(todos.first.title, 'Write tests');
      expect(fakeRepository.getTodosCallCount, 1);
    });

    test('adds a todo and refreshes state', () async {
      await container.read(todoUsecaseProvider.future);

      await container
          .read(todoUsecaseProvider.notifier)
          .addTodo(
            title: 'Review PR',
            priority: TodoPriority.high,
            dueDate: DateTime(2026, 1, 4),
            colorValue: 'FFEF5350',
          );
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos, hasLength(2));
      expect(todos.last.title, 'Review PR');
      expect(todos.last.isCompleted, isFalse);
      expect(todos.last.priority, TodoPriority.high);
      expect(todos.last.dueDate, DateTime(2026, 1, 4));
      expect(todos.last.colorValue, 'FFEF5350');
      expect(fakeRepository.addedTodos, hasLength(1));
      expect(fakeRepository.addedTodos.single.title, 'Review PR');
    });

    test('trims input before adding a todo', () async {
      await container.read(todoUsecaseProvider.future);

      await container
          .read(todoUsecaseProvider.notifier)
          .addTodo(title: '  Trim me  ');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos.last.title, 'Trim me');
      expect(fakeRepository.addedTodos.single.title, 'Trim me');
    });

    test('does not add an empty todo after trimming', () async {
      await container.read(todoUsecaseProvider.future);

      await container.read(todoUsecaseProvider.notifier).addTodo(title: '   ');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos, hasLength(1));
      expect(fakeRepository.addedTodos, isEmpty);
      expect(fakeRepository.getTodosCallCount, 1);
    });

    test('toggles a todo and refreshes state', () async {
      await container.read(todoUsecaseProvider.future);

      await container.read(todoUsecaseProvider.notifier).toggleTodo('1');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos.single.isCompleted, isTrue);
      expect(fakeRepository.toggledTodoIds, ['1']);
    });

    test('edits a todo and refreshes state', () async {
      await container.read(todoUsecaseProvider.future);

      await container
          .read(todoUsecaseProvider.notifier)
          .editTodo(
            '1',
            title: 'New title',
            priority: TodoPriority.medium,
            dueDate: DateTime(2026, 1, 6),
            colorValue: 'FF26A69A',
          );
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos.single.title, 'New title');
      expect(todos.single.priority, TodoPriority.medium);
      expect(todos.single.dueDate, DateTime(2026, 1, 6));
      expect(todos.single.colorValue, 'FF26A69A');
      expect(fakeRepository.editedTodos, [
        (
          '1',
          'New title',
          TodoPriority.medium,
          DateTime(2026, 1, 6),
          'FF26A69A',
        ),
      ]);
    });

    test('trims input before editing a todo', () async {
      await container.read(todoUsecaseProvider.future);

      await container
          .read(todoUsecaseProvider.notifier)
          .editTodo(
            '1',
            title: '  Updated title  ',
            priority: TodoPriority.high,
            dueDate: DateTime(2026, 1, 7),
            colorValue: 'FFFFB020',
          );
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos.single.title, 'Updated title');
      expect(fakeRepository.editedTodos.single.$2, 'Updated title');
    });

    test('does not edit a todo with empty text after trimming', () async {
      await container.read(todoUsecaseProvider.future);

      await container
          .read(todoUsecaseProvider.notifier)
          .editTodo(
            '1',
            title: '   ',
            priority: TodoPriority.high,
            dueDate: DateTime(2026, 1, 8),
            colorValue: 'FFAB47BC',
          );
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos.single.title, 'Write tests');
      expect(fakeRepository.editedTodos, isEmpty);
      expect(fakeRepository.getTodosCallCount, 1);
    });

    test('deletes a todo and refreshes state', () async {
      await container.read(todoUsecaseProvider.future);

      await container.read(todoUsecaseProvider.notifier).deleteTodo('1');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos, isEmpty);
      expect(fakeRepository.deletedTodoIds, ['1']);
    });

    test('toggle keeps metadata intact', () async {
      await container.read(todoUsecaseProvider.future);

      await container.read(todoUsecaseProvider.notifier).toggleTodo('1');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos.single.isCompleted, isTrue);
      expect(todos.single.priority, TodoPriority.low);
      expect(todos.single.dueDate, DateTime(2026, 1, 3));
      expect(todos.single.colorValue, 'FF5B8DEF');
    });
  });

  group('error handling', () {
    test('state becomes AsyncError when getTodos throws after addTodo', () async {
      final fakeRepository = _FakeTodoRepository(todos: []);
      final container = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(fakeRepository)],
      );
      addTearDown(container.dispose);

      await container.read(todoUsecaseProvider.future);

      fakeRepository.throwOnNextGet = true;
      await container
          .read(todoUsecaseProvider.notifier)
          .addTodo(title: 'Task A');

      final state = container.read(todoUsecaseProvider);
      expect(state.hasError, isTrue);
    });

    test('state becomes AsyncError when getTodos throws after toggleTodo', () async {
      final fakeRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: 'x',
            title: 'T',
            createdAt: DateTime(2026),
            isCompleted: false,
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(fakeRepository)],
      );
      addTearDown(container.dispose);

      await container.read(todoUsecaseProvider.future);

      fakeRepository.throwOnNextGet = true;
      await container.read(todoUsecaseProvider.notifier).toggleTodo('x');

      final state = container.read(todoUsecaseProvider);
      expect(state.hasError, isTrue);
    });

    test('provider recovers after invalidate following an error', () async {
      final fakeRepository = _FakeTodoRepository(todos: []);
      final container = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(fakeRepository)],
      );
      addTearDown(container.dispose);

      await container.read(todoUsecaseProvider.future);

      fakeRepository.throwOnNextGet = true;
      await container
          .read(todoUsecaseProvider.notifier)
          .addTodo(title: 'Task B');
      expect(container.read(todoUsecaseProvider).hasError, isTrue);

      // invalidate → provider rebuild → getTodos ปกติ
      container.invalidate(todoUsecaseProvider);
      final todos = await container.read(todoUsecaseProvider.future);
      expect(todos, isA<List<Todo>>());
    });
  });

  group('UUID ID generation', () {
    late _FakeTodoRepository fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = _FakeTodoRepository(todos: []);
      container = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(fakeRepository)],
      );
    });

    tearDown(() => container.dispose());

    test('generated IDs are unique across rapid successive adds', () async {
      await container.read(todoUsecaseProvider.future);
      await Future.wait([
        container
            .read(todoUsecaseProvider.notifier)
            .addTodo(title: 'Task A'),
        container
            .read(todoUsecaseProvider.notifier)
            .addTodo(title: 'Task B'),
      ]);
      final todos = await container.read(todoUsecaseProvider.future);
      final ids = todos.map((t) => t.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'IDs must be unique');
    });

    test('generated ID matches UUID v4 format', () async {
      await container.read(todoUsecaseProvider.future);
      await container
          .read(todoUsecaseProvider.notifier)
          .addTodo(title: 'UUID test');
      final todos = await container.read(todoUsecaseProvider.future);
      final newId = todos.last.id;
      final uuidV4 = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(uuidV4.hasMatch(newId), isTrue, reason: 'ID should be UUID v4');
    });
  });
}

class _FakeTodoRepository implements TodoRepository {
  _FakeTodoRepository({required List<Todo> todos}) : _todos = List.of(todos);

  final List<Todo> _todos;
  final List<Todo> addedTodos = [];
  final List<(String, String, TodoPriority, DateTime?, String?)> editedTodos =
      [];
  final List<String> toggledTodoIds = [];
  final List<String> deletedTodoIds = [];
  int getTodosCallCount = 0;
  bool throwOnNextGet = false;

  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    addedTodos.add(todo);
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    _todos.removeWhere((todo) => todo.id == todoId);
    deletedTodoIds.add(todoId);
  }

  @override
  Future<List<Todo>> getTodos() async {
    getTodosCallCount++;
    if (throwOnNextGet) {
      throwOnNextGet = false;
      throw Exception('Storage error');
    }
    return List.unmodifiable(_todos);
  }

  @override
  Future<void> editTodo(
    String todoId, {
    required String title,
    required TodoPriority priority,
    DateTime? dueDate,
    String? colorValue,
  }) async {
    final index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index == -1) return;

    _todos[index] = _todos[index].copyWith(
      title: title,
      priority: priority,
      dueDate: dueDate,
      colorValue: colorValue,
    );
    editedTodos.add((todoId, title, priority, dueDate, colorValue));
  }

  @override
  Future<void> toggleTodo(String todoId) async {
    final index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index == -1) return;

    final todo = _todos[index];
    _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
    toggledTodoIds.add(todoId);
  }
}
