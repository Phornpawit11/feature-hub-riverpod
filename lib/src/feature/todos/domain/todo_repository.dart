import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> toggleTodo(String todoId);
  Future<void> deleteTodo(String todoId);
}
