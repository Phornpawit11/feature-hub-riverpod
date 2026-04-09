import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';

part 'todo_hive_model.g.dart';

@HiveType(typeId: 0)
class TodoHiveModel extends HiveObject {
  TodoHiveModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.isCompleted,
  });

  factory TodoHiveModel.fromDomain(Todo todo) {
    return TodoHiveModel(
      id: todo.id,
      title: todo.title,
      createdAt: todo.createdAt,
      isCompleted: todo.isCompleted,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final bool isCompleted;

  Todo toDomain() {
    return Todo(
      id: id,
      title: title,
      createdAt: createdAt,
      isCompleted: isCompleted,
    );
  }
}
