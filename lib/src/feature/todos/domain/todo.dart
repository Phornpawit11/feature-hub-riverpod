import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoPriority {
  low,
  medium,
  high;

  String get label => switch (this) {
    TodoPriority.low => 'Low',
    TodoPriority.medium => 'Medium',
    TodoPriority.high => 'High',
  };
}

@freezed
abstract class Todo with _$Todo {
  factory Todo({
    required String id,
    required String title,
    required DateTime createdAt,
    required bool isCompleted,
    @Default(TodoPriority.low) TodoPriority priority,
    DateTime? dueDate,
    String? colorValue,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
