import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_editor_fields.dart';

class TodoComposerCard extends StatelessWidget {
  const TodoComposerCard({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.controller,
    required this.priority,
    required this.dueDate,
    required this.colorValue,
    required this.buttonLabel,
    required this.onExpand,
    required this.onCollapse,
    required this.onPriorityChanged,
    required this.onDueDateChanged,
    required this.onColorChanged,
    required this.onSubmit,
  });

  final String title;
  final bool isExpanded;
  final TextEditingController controller;
  final TodoPriority priority;
  final DateTime? dueDate;
  final String? colorValue;
  final String buttonLabel;
  final VoidCallback onExpand;
  final VoidCallback onCollapse;
  final ValueChanged<TodoPriority> onPriorityChanged;
  final ValueChanged<DateTime?> onDueDateChanged;
  final ValueChanged<String?> onColorChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isExpanded
              ? _ExpandedComposer(
                  key: const ValueKey('expanded-composer'),
                  title: title,
                  controller: controller,
                  priority: priority,
                  dueDate: dueDate,
                  colorValue: colorValue,
                  buttonLabel: buttonLabel,
                  onCollapse: onCollapse,
                  onPriorityChanged: onPriorityChanged,
                  onDueDateChanged: onDueDateChanged,
                  onColorChanged: onColorChanged,
                  onSubmit: onSubmit,
                )
              : _CollapsedComposer(
                  key: const ValueKey('collapsed-composer'),
                  onExpand: onExpand,
                ),
        ),
      ),
    );
  }
}

class _CollapsedComposer extends StatelessWidget {
  const _CollapsedComposer({super.key, required this.onExpand});

  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onExpand,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.add_rounded, color: cs.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add task',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Create a new task with optional details',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _ExpandedComposer extends StatelessWidget {
  const _ExpandedComposer({
    super.key,
    required this.title,
    required this.controller,
    required this.priority,
    required this.dueDate,
    required this.colorValue,
    required this.buttonLabel,
    required this.onCollapse,
    required this.onPriorityChanged,
    required this.onDueDateChanged,
    required this.onColorChanged,
    required this.onSubmit,
  });

  final String title;
  final TextEditingController controller;
  final TodoPriority priority;
  final DateTime? dueDate;
  final String? colorValue;
  final String buttonLabel;
  final VoidCallback onCollapse;
  final ValueChanged<TodoPriority> onPriorityChanged;
  final ValueChanged<DateTime?> onDueDateChanged;
  final ValueChanged<String?> onColorChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      key: const ValueKey('composer-content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(onPressed: onCollapse, child: const Text('Cancel')),
          ],
        ),
        const SizedBox(height: 12),
        TodoEditorFields(
          controller: controller,
          priority: priority,
          dueDate: dueDate,
          colorValue: colorValue,
          onPriorityChanged: onPriorityChanged,
          onDueDateChanged: onDueDateChanged,
          onColorChanged: onColorChanged,
          onSubmitted: onSubmit,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.add_task_rounded),
            label: Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}
