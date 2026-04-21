import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/date_tag_list_item.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';

class DateTagSelector extends StatelessWidget {
  const DateTagSelector({
    super.key,
    required this.tags,
    required this.onTagSelected,
    required this.onTagEdit,
    this.enabled = true,
  });

  final List<DateTag> tags;
  final Future<void> Function(DateTag tag) onTagSelected;
  final ValueChanged<DateTag> onTagEdit;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (tags.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Text(
          'No tags yet. Create your first one below.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      );
    }

    const spacing = 10.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (spacing * 3)) / 4;

        return Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: tags
                .map(
                  (tag) => SizedBox(
                    width: itemWidth,
                    child: DateTagListItem(
                      tag: tag,
                      onSelect: enabled ? () => onTagSelected(tag) : null,
                      onManage: enabled ? () => onTagEdit(tag) : null,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class DateTagColorSelector extends StatelessWidget {
  const DateTagColorSelector({
    super.key,
    required this.selectedColorValue,
    required this.onSelected,
  });

  final String selectedColorValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final availableColors = todoColors.whereType<String>().toList();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: availableColors.map((colorValue) {
        final isSelected = colorValue == selectedColorValue;
        final color = parseTodoColor(colorValue) ?? cs.primary;
        final foregroundColor = foregroundColorForBackground(color);

        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onSelected(colorValue),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? cs.onSurface.withValues(alpha: 0.3)
                    : Colors.transparent,
                width: isSelected ? 2 : 1.2,
              ),
            ),
            child: isSelected
                ? Icon(Icons.check_rounded, color: foregroundColor, size: 18)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
