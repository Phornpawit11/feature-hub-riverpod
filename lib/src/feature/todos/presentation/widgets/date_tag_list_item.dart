import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';

class DateTagListItem extends StatelessWidget {
  const DateTagListItem({
    super.key,
    required this.tag,
    required this.onSelect,
    required this.onManage,
  });

  final DateTag tag;
  final VoidCallback onSelect;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = parseTodoColor(tag.colorValue) ?? cs.primary;

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onSelect,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tag.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit ${tag.name}',
                onPressed: onManage,
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
