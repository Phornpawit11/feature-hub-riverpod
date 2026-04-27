import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_empty_state.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_tile.dart';

class TodoListSection extends StatelessWidget {
  const TodoListSection({
    super.key,
    required this.todos,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Todo> todos;
  final ValueChanged<Todo> onEdit;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const TodoEmptyState(
        title: 'No tasks yet',
        subtitle:
            'Add your first task above with a priority, due date, and color.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return Padding(
              key: ValueKey(todo.id),
              padding: const EdgeInsets.only(bottom: 10),
              child: TodoTile(
                todo: todo,
                onEdit: () => onEdit(todo),
                onToggle: () => onToggle(todo.id),
                onDelete: () => onDelete(todo.id),
              ),
            );
          },
        ),
      ],
    );
  }
}
