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
  final VoidCallback? onSelect;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = parseTodoColor(tag.colorValue) ?? cs.primary;
    final isEnabled = onSelect != null;
    final useDarkForeground = color.computeLuminance() > 0.5;
    final backgroundColor = color.withValues(alpha: isEnabled ? 0.22 : 0.10);
    final foregroundColor = useDarkForeground
        ? Colors.black.withValues(alpha: 0.78)
        : Colors.white.withValues(alpha: 0.94);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onSelect,
        child: Container(
          height: 72,
          padding: const EdgeInsets.fromLTRB(8, 0, 4, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: backgroundColor,
            border: Border.all(
              color: color.withValues(alpha: isEnabled ? 0.26 : 0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Edit ${tag.name}',
                    onPressed: onManage,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 22,
                      height: 22,
                    ),
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      size: 14,
                      color: foregroundColor.withValues(
                        alpha: isEnabled ? 0.82 : 0.48,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    tag.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: foregroundColor.withValues(
                        alpha: isEnabled ? 1 : 0.6,
                      ),
                    ),
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
