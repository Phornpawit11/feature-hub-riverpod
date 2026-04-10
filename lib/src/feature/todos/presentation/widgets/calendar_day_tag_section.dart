import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/date_tag_chip.dart';

class CalendarDayTagSection extends StatelessWidget {
  const CalendarDayTagSection({
    super.key,
    required this.assignedTag,
    required this.onAddTag,
    required this.onChangeTag,
    required this.onRemoveTag,
  });

  final DateTag? assignedTag;
  final VoidCallback onAddTag;
  final VoidCallback onChangeTag;
  final VoidCallback onRemoveTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tag',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          if (assignedTag == null) ...[
            Text(
              'No tag assigned for this day yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onAddTag,
              icon: const Icon(Icons.label_outline_rounded),
              label: const Text('Add tag'),
            ),
          ] else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DateTagChip(tag: assignedTag!),
                TextButton(onPressed: onChangeTag, child: const Text('Change')),
                TextButton(
                  onPressed: onRemoveTag,
                  child: Text('Remove', style: TextStyle(color: cs.error)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
