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
    this.priorityKey = 'medium',
    this.dueDate,
    this.colorValue,
  });

  factory TodoHiveModel.fromDomain(Todo todo) {
    return TodoHiveModel(
      id: todo.id,
      title: todo.title,
      createdAt: todo.createdAt,
      isCompleted: todo.isCompleted,
      priorityKey: todo.priority.name,
      dueDate: todo.dueDate,
      colorValue: todo.colorValue,
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

  @HiveField(4, defaultValue: 'medium')
  final String priorityKey;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6)
  final String? colorValue;

  Todo toDomain() {
    return Todo(
      id: id,
      title: title,
      createdAt: createdAt,
      isCompleted: isCompleted,
      priority: TodoPriority.values.firstWhere(
        (priority) => priority.name == priorityKey,
        orElse: () => TodoPriority.medium,
      ),
      dueDate: dueDate,
      colorValue: colorValue,
    );
  }
}
