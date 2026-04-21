import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/todo_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/todo_hive_model.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';

part 'todo_repository_impl.g.dart';

@riverpod
class TodoRepositoryImpl extends _$TodoRepositoryImpl
    implements TodoRepository {
  TodoLocalDatasource get _datasourceProvider =>
      ref.read(todoLocalDatasourceProvider.notifier);

  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  @override
  Future<List<Todo>> getTodos() async {
    final todos = await _datasourceProvider.getTodos();
    return todos.map((todo) => todo.toDomain()).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await _datasourceProvider.putTodo(TodoHiveModel.fromDomain(todo));
  }

  @override
  Future<void> editTodo(
    String todoId, {
    required String title,
    required TodoPriority priority,
    DateTime? dueDate,
    String? colorValue,
  }) async {
    final existingTodo = await _datasourceProvider.getTodoById(todoId);
    if (existingTodo == null) return;

    await _datasourceProvider.putTodo(
      TodoHiveModel(
        id: existingTodo.id,
        title: title,
        createdAt: existingTodo.createdAt,
        isCompleted: existingTodo.isCompleted,
        priorityKey: priority.name,
        dueDate: dueDate,
        colorValue: colorValue,
      ),
    );
  }

  @override
  Future<void> toggleTodo(String todoId) async {
    final todo = await _datasourceProvider.getTodoById(todoId);
    if (todo == null) return;

    await _datasourceProvider.putTodo(
      TodoHiveModel(
        id: todo.id,
        title: todo.title,
        createdAt: todo.createdAt,
        isCompleted: !todo.isCompleted,
        priorityKey: todo.priorityKey,
        dueDate: todo.dueDate,
        colorValue: todo.colorValue,
      ),
    );
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _datasourceProvider.deleteTodo(todoId);
  }
}
