import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_tile.dart';

void main() {
  group('TodoTile', () {
    testWidgets('calls onToggle when completion button is tapped', (
      tester,
    ) async {
      var toggled = false;

      await tester.pumpWidget(
        _buildSubject(todo: _todo(), onToggle: () => toggled = true),
      );

      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();

      expect(toggled, isTrue);
    });

    testWidgets('shows overflow menu with edit and delete actions', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(todo: _todo()));

      await tester.tap(find.byIcon(Icons.more_horiz_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('calls onEdit from overflow menu', (tester) async {
      var edited = false;

      await tester.pumpWidget(
        _buildSubject(todo: _todo(), onEdit: () => edited = true),
      );

      await tester.tap(find.byIcon(Icons.more_horiz_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(edited, isTrue);
    });

    testWidgets('calls onDelete from overflow menu', (tester) async {
      var deleted = false;

      await tester.pumpWidget(
        _buildSubject(todo: _todo(), onDelete: () => deleted = true),
      );

      await tester.tap(find.byIcon(Icons.more_horiz_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    });

    testWidgets('renders completed title with line through decoration', (
      tester,
    ) async {
      await tester.pumpWidget(_buildSubject(todo: _todo(isCompleted: true)));

      final title = tester.widget<Text>(find.text('Ship calendar redesign'));
      expect(title.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('renders without due date and color metadata', (tester) async {
      await tester.pumpWidget(
        _buildSubject(todo: _todo(dueDate: null, colorValue: null)),
      );

      expect(find.text('Ship calendar redesign'), findsOneWidget);
      expect(find.text('Low'), findsOneWidget);
      expect(find.text('Accent'), findsNothing);
      expect(find.byIcon(Icons.flag_rounded), findsNothing);
      expect(find.byIcon(Icons.circle_rounded), findsWidgets);
    });
  });
}

Widget _buildSubject({
  required Todo todo,
  VoidCallback? onEdit,
  VoidCallback? onToggle,
  VoidCallback? onDelete,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 360,
          child: TodoTile(
            todo: todo,
            onEdit: onEdit ?? () {},
            onToggle: onToggle ?? () {},
            onDelete: onDelete ?? () {},
          ),
        ),
      ),
    ),
  );
}

Todo _todo({
  bool isCompleted = false,
  DateTime? dueDate,
  String? colorValue = '4294951175',
}) {
  return Todo(
    id: 'todo-1',
    title: 'Ship calendar redesign',
    createdAt: DateTime(2026, 4, 10),
    isCompleted: isCompleted,
    priority: TodoPriority.low,
    dueDate: dueDate ?? DateTime(2026, 4, 14),
    colorValue: colorValue,
  );
}
