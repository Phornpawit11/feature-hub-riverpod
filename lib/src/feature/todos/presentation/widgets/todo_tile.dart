import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => onToggle(),
          ),
          title: Text(
            todo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: todo.isCompleted ? cs.onSurfaceVariant : cs.onSurface,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TodoMetaChip(
                  icon: Icons.flag_rounded,
                  label: todo.priority.label,
                  color: priorityColor(todo.priority),
                ),
                if (todo.dueDate != null)
                  _TodoMetaChip(
                    icon: Icons.event_rounded,
                    label: formatTodoDate(todo.dueDate!),
                    color: cs.secondary,
                  ),
                if (todo.colorValue != null)
                  _TodoMetaChip(
                    icon: Icons.palette_outlined,
                    label: 'Color',
                    color: parseTodoColor(todo.colorValue) ?? cs.tertiary,
                  ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: cs.onSurfaceVariant),
                tooltip: 'Edit todo',
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: cs.onSurfaceVariant),
                tooltip: 'Delete todo',
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodoMetaChip extends StatelessWidget {
  const _TodoMetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color.withValues(alpha: 0.85)),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
