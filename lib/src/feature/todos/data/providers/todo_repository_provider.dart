import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/todos/data/repository/todo_repository_impl.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';

part 'todo_repository_provider.g.dart';

@riverpod
TodoRepository todoRepository(Ref ref) {
  return ref.watch(todoRepositoryImplProvider.notifier);
}
