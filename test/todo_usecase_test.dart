import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            createdAt: DateTime(2026, 1, 1),
            isCompleted: false,
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

      await container.read(todoUsecaseProvider.notifier).addTodo('Review PR');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos, hasLength(2));
      expect(todos.last.title, 'Review PR');
      expect(todos.last.isCompleted, isFalse);
      expect(fakeRepository.addedTodos, hasLength(1));
      expect(fakeRepository.addedTodos.single.title, 'Review PR');
    });

    test('trims input before adding a todo', () async {
      await container.read(todoUsecaseProvider.future);

      await container.read(todoUsecaseProvider.notifier).addTodo('  Trim me  ');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos.last.title, 'Trim me');
      expect(fakeRepository.addedTodos.single.title, 'Trim me');
    });

    test('does not add an empty todo after trimming', () async {
      await container.read(todoUsecaseProvider.future);

      await container.read(todoUsecaseProvider.notifier).addTodo('   ');
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

    test('deletes a todo and refreshes state', () async {
      await container.read(todoUsecaseProvider.future);

      await container.read(todoUsecaseProvider.notifier).deleteTodo('1');
      final todos = await container.read(todoUsecaseProvider.future);

      expect(todos, isEmpty);
      expect(fakeRepository.deletedTodoIds, ['1']);
    });
  });
}

class _FakeTodoRepository implements TodoRepository {
  _FakeTodoRepository({required List<Todo> todos}) : _todos = List.of(todos);

  final List<Todo> _todos;
  final List<Todo> addedTodos = [];
  final List<String> toggledTodoIds = [];
  final List<String> deletedTodoIds = [];
  int getTodosCallCount = 0;

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
    return List.unmodifiable(_todos);
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
