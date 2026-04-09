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
      ref.watch(todoLocalDatasourceProvider.notifier);

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
  Future<void> toggleTodo(String todoId) async {
    final todos = await _datasourceProvider.getTodos();
    for (final todo in todos) {
      if (todo.id == todoId) {
        await _datasourceProvider.putTodo(
          TodoHiveModel(
            id: todo.id,
            title: todo.title,
            createdAt: todo.createdAt,
            isCompleted: !todo.isCompleted,
          ),
        );
      }
      return;
    }
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _datasourceProvider.deleteTodo(todoId);
  }
}
