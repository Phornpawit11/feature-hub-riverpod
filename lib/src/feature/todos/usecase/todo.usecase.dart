import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/todo_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';

part 'todo.usecase.g.dart';

@riverpod
class TodoUsecase extends _$TodoUsecase {
  TodoRepository get _todoRepository => ref.read(todoRepositoryProvider);

  @override
  FutureOr<List<Todo>> build() async {
    final todoList = await _todoRepository.getTodos();
    // if (todoList.isEmpty) {
    //   for (var index = 0; index < 3; index++) {
    //     await _todoRepository.addTodo(
    //       Todo(
    //         id: DateTime.now().toString(),
    //         title: 'ตำแหน่ง $index',
    //         createdAt: DateTime.now(),
    //         isCompleted: false,
    //       ),
    //     );
    //   }
    //   await Future.delayed(const Duration(seconds: 2));
    //   return await _todoRepository.getTodos();
    // }
    return todoList;
  }

  Future<void> toggleTodo(String todoId) async {
    await _todoRepository.toggleTodo(todoId);
    state = AsyncData<List<Todo>>(await _todoRepository.getTodos());
  }

  Future<void> deleteTodo(String todoId) async {
    await _todoRepository.deleteTodo(todoId);
    state = AsyncData<List<Todo>>(await _todoRepository.getTodos());
  }

  Future<void> addTodo(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return;
    }
    final newTodo = Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedText,
      createdAt: DateTime.now(),
      isCompleted: false,
    );
    await _todoRepository.addTodo(newTodo);
    state = AsyncData<List<Todo>>(await _todoRepository.getTodos());
  }
}
