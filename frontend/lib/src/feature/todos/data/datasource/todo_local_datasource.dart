import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/storage/hive_boxes.dart';
import 'package:todos_riverpod/src/feature/todos/data/model/todo_hive_model.dart';

part 'todo_local_datasource.g.dart';

@riverpod
class TodoLocalDatasource extends _$TodoLocalDatasource {
  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  Future<List<TodoHiveModel>> getTodos() async {
    final todos = Hive.box<TodoHiveModel>(HiveBoxes.todos).values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todos;
  }

  Future<void> putTodo(TodoHiveModel todo) async {
    await Hive.box<TodoHiveModel>(HiveBoxes.todos).put(todo.id, todo);
  }

  Future<TodoHiveModel?> getTodoById(String todoId) async {
    return Hive.box<TodoHiveModel>(HiveBoxes.todos).get(todoId);
  }

  Future<void> deleteTodo(String todoId) async {
    await Hive.box<TodoHiveModel>(HiveBoxes.todos).delete(todoId);
  }
}
