import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/todo_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';
import 'package:uuid/uuid.dart';

part 'todo.usecase.g.dart';

@riverpod
class TodoUsecase extends _$TodoUsecase {
  TodoRepository get _todoRepository => ref.read(todoRepositoryProvider);

  @override
  FutureOr<List<Todo>> build() async {
    final todoList = await _todoRepository.getTodos();

    return todoList;
  }

  Future<void> toggleTodo(String todoId) async {
    await _todoRepository.toggleTodo(todoId);
    await _refreshTodos();
  }

  Future<void> deleteTodo(String todoId) async {
    await _todoRepository.deleteTodo(todoId);
    await _refreshTodos();
  }

  Future<void> addTodo({
    required String title,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
    String? colorValue,
  }) async {
    final trimmedText = title.trim();
    if (trimmedText.isEmpty) {
      return;
    }

    final newTodo = Todo(
      id: const Uuid().v4(),
      title: trimmedText,
      createdAt: DateTime.now(),
      isCompleted: false,
      priority: priority,
      dueDate: dueDate,
      colorValue: colorValue,
    );

    await _todoRepository.addTodo(newTodo);
    await _refreshTodos();
  }

  Future<void> editTodo(
    String todoId, {
    required String title,
    required TodoPriority priority,
    DateTime? dueDate,
    String? colorValue,
  }) async {
    final trimmedText = title.trim();
    if (trimmedText.isEmpty) {
      return;
    }

    await _todoRepository.editTodo(
      todoId,
      title: trimmedText,
      priority: priority,
      dueDate: dueDate,
      colorValue: colorValue,
    );
    await _refreshTodos();
  }

  Future<void> _refreshTodos() async {
    state = await AsyncValue.guard(() => _todoRepository.getTodos());
  }
}
