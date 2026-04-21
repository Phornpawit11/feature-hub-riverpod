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
    final accentColor =
        parseTodoColor(todo.colorValue) ?? priorityColor(todo.priority);
    final isCompleted = todo.isCompleted;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: isCompleted ? cs.onSurfaceVariant : cs.onSurface,
      decoration: isCompleted ? TextDecoration.lineThrough : null,
      decorationColor: cs.onSurfaceVariant,
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? cs.outlineVariant.withValues(alpha: 0.35)
                : cs.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: _TodoCompletionButton(
                          isCompleted: isCompleted,
                          accentColor: accentColor,
                          onPressed: onToggle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle,
                            ),
                            const SizedBox(height: 10),
                            _TodoMetaRow(todo: todo, accentColor: accentColor),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      _TodoOverflowMenu(onEdit: onEdit, onDelete: onDelete),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodoCompletionButton extends StatelessWidget {
  const _TodoCompletionButton({
    required this.isCompleted,
    required this.accentColor,
    required this.onPressed,
  });

  final bool isCompleted;
  final Color accentColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? accentColor : cs.surface,
            border: Border.all(
              color: isCompleted ? accentColor : cs.outlineVariant,
              width: isCompleted ? 1.5 : 1.2,
            ),
          ),
          child: Icon(
            Icons.check_rounded,
            size: 17,
            color: isCompleted ? Colors.white : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _TodoMetaRow extends StatelessWidget {
  const _TodoMetaRow({required this.todo, required this.accentColor});

  final Todo todo;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = <Widget>[
      _TodoMetaChip(
        icon: Icons.circle_rounded,
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
          icon: Icons.circle_rounded,
          label: 'Accent',
          color: accentColor,
        ),
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(spacing: 8, runSpacing: 8, children: items);
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color.withValues(alpha: 0.90)),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoOverflowMenu extends StatelessWidget {
  const _TodoOverflowMenu({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopupMenuButton<_TodoTileAction>(
      tooltip: 'More actions',
      icon: Icon(Icons.more_horiz_rounded, color: cs.onSurfaceVariant),
      onSelected: (value) {
        switch (value) {
          case _TodoTileAction.edit:
            onEdit();
          case _TodoTileAction.delete:
            onDelete();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: _TodoTileAction.edit, child: Text('Edit')),
        PopupMenuItem(value: _TodoTileAction.delete, child: Text('Delete')),
      ],
    );
  }
}

enum _TodoTileAction { edit, delete }
