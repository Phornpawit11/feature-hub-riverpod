import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';

class DateTagChip extends StatelessWidget {
  const DateTagChip({super.key, required this.tag});

  final DateTag tag;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = parseTodoColor(tag.colorValue) ?? cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            tag.name,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
