import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_editor_fields.dart';

void main() {
  group('TodoEditorFields', () {
    testWidgets('shows circle priority icons instead of flags', (tester) async {
      await tester.pumpWidget(_buildSubject());

      expect(find.byIcon(Icons.flag_rounded), findsNothing);
      expect(find.byIcon(Icons.circle_rounded), findsAtLeastNWidgets(2));
      expect(find.text('Low'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
    });

    testWidgets('calls onPriorityChanged when selecting another priority', (
      tester,
    ) async {
      TodoPriority? selectedPriority;

      await tester.pumpWidget(
        _buildSubject(
          priority: TodoPriority.low,
          onPriorityChanged: (value) => selectedPriority = value,
        ),
      );

      await tester.tap(find.text('High'));
      await tester.pumpAndSettle();

      expect(selectedPriority, TodoPriority.high);
    });
  });
}

Widget _buildSubject({
  TodoPriority priority = TodoPriority.medium,
  ValueChanged<TodoPriority>? onPriorityChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: TodoEditorFields(
        controller: TextEditingController(),
        priority: priority,
        dueDate: null,
        colorValue: null,
        onPriorityChanged: onPriorityChanged ?? (_) {},
        onDueDateChanged: (_) {},
        onColorChanged: (_) {},
        onSubmitted: () async {},
      ),
    ),
  );
}
