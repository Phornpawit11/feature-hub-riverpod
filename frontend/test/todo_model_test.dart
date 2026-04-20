import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';

void main() {
  group('Todo json', () {
    test('deserializes with defaults for legacy payloads', () {
      final todo = Todo.fromJson({
        'id': '1',
        'title': 'Legacy todo',
        'createdAt': '2026-01-01T00:00:00.000',
        'isCompleted': false,
      });

      expect(todo.priority, TodoPriority.low);
      expect(todo.dueDate, isNull);
      expect(todo.colorValue, isNull);
    });

    test('serializes and deserializes metadata fields', () {
      final todo = Todo(
        id: '2',
        title: 'Plan sprint',
        createdAt: DateTime(2026, 1, 2),
        isCompleted: false,
        priority: TodoPriority.high,
        dueDate: DateTime(2026, 1, 5),
        colorValue: 'FF26A69A',
      );

      final decoded = Todo.fromJson(todo.toJson());

      expect(decoded.priority, TodoPriority.high);
      expect(decoded.dueDate, DateTime(2026, 1, 5));
      expect(decoded.colorValue, 'FF26A69A');
    });
  });
}
