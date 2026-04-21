import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/calendar_day_tag_section.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_empty_state.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_tile.dart';

Key _calendarDayLabelKey(DateTime day) =>
    ValueKey('calendar-day-label-${day.year}-${day.month}-${day.day}');

class TodoCalendarSection extends StatelessWidget {
  const TodoCalendarSection({
    super.key,
    required this.todos,
    required this.focusedMonth,
    required this.selectedDate,
    required this.dateTagsByDay,
    required this.onMonthChanged,
    required this.onDateSelected,
    required this.onAddTag,
    required this.onChangeTag,
    required this.onRemoveTag,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Todo> todos;
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<DateTime, DateTag> dateTagsByDay;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onAddTag;
  final VoidCallback onChangeTag;
  final VoidCallback onRemoveTag;
  final ValueChanged<Todo> onEdit;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    final dueTodos = todos.where((todo) => todo.dueDate != null).toList();
    final groupedTodos = <DateTime, List<Todo>>{};

    for (final todo in dueTodos) {
      final key = dateOnly(todo.dueDate!);
      groupedTodos.putIfAbsent(key, () => <Todo>[]).add(todo);
    }

    final monthDays = buildMonthDays(focusedMonth);
    final selectedTodos =
        groupedTodos[dateOnly(selectedDate)] ?? const <Todo>[];
    final assignedTag = dateTagsByDay[dateOnly(selectedDate)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CalendarHeader(
          focusedMonth: focusedMonth,
          onPreviousMonth: () => onMonthChanged(
            DateTime(focusedMonth.year, focusedMonth.month - 1),
          ),
          onNextMonth: () => onMonthChanged(
            DateTime(focusedMonth.year, focusedMonth.month + 1),
          ),
        ),
        const SizedBox(height: 12),
        _CalendarGrid(
          monthDays: monthDays,
          selectedDate: selectedDate,
          dateTagsByDay: dateTagsByDay,
          todosByDay: groupedTodos,
          onDateSelected: onDateSelected,
          onPreviousMonth: () => onMonthChanged(
            DateTime(focusedMonth.year, focusedMonth.month - 1),
          ),
          onNextMonth: () => onMonthChanged(
            DateTime(focusedMonth.year, focusedMonth.month + 1),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Due on ${formatTodoDate(selectedDate)}',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        CalendarDayTagSection(
          assignedTag: assignedTag,
          onAddTag: onAddTag,
          onChangeTag: onChangeTag,
          onRemoveTag: onRemoveTag,
        ),
        const SizedBox(height: 16),
        if (selectedTodos.isEmpty)
          const Center(
            child: TodoEmptyState(
              title: 'Nothing due on this day',
              subtitle:
                  'Try selecting another date, or add a due date to more tasks.',
            ),
          )
        else
          ...selectedTodos.map(
            (todo) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TodoTile(
                todo: todo,
                onEdit: () => onEdit(todo),
                onToggle: () => onToggle(todo.id),
                onDelete: () => onDelete(todo.id),
              ),
            ),
          ),
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.focusedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime focusedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            formatTodoMonth(focusedMonth),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.monthDays,
    required this.selectedDate,
    required this.dateTagsByDay,
    required this.todosByDay,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  static const double _monthSwipeVelocityThreshold = 240;

  final List<DateTime?> monthDays;
  final DateTime selectedDate;
  final Map<DateTime, DateTag> dateTagsByDay;
  final Map<DateTime, List<Todo>> todosByDay;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),

      child: Column(
        children: [
          GridView.builder(
            itemCount: todoWeekdayLabels.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) => Center(
              child: Text(
                todoWeekdayLabels[index],
                style: theme.textTheme.labelMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity <= -_monthSwipeVelocityThreshold) {
                onNextMonth();
              } else if (velocity >= _monthSwipeVelocityThreshold) {
                onPreviousMonth();
              }
            },
            child: GridView.builder(
              itemCount: monthDays.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final day = monthDays[index];
                if (day == null) {
                  return const SizedBox.shrink();
                }

                final dateKey = dateOnly(day);
                final isSelected = dateKey == dateOnly(selectedDate);
                final isToday = dateKey == dateOnly(DateTime.now());
                final todos = todosByDay[dateKey] ?? const <Todo>[];
                final dateTag = dateTagsByDay[dateKey];
                final hasDateTag = dateTag != null;
                final dateTagName = dateTag == null ? "" : dateTag.name;
                final dateTagColor = dateTag == null
                    ? null
                    : parseTodoColor(dateTag.colorValue);
                final accentColors = todos
                    .map(
                      (todo) =>
                          parseTodoColor(todo.colorValue) ??
                          priorityColor(todo.priority),
                    )
                    .take(3)
                    .toList();
                final backgroundColor = switch ((isSelected, dateTagColor)) {
                  (true, final color?) => color.withValues(alpha: 0.12),
                  (true, null) => cs.primary.withValues(alpha: 0.10),
                  (false, final color?) => color.withValues(alpha: 0.06),
                  (false, null) => Colors.transparent,
                };
                final borderColor = isSelected
                    ? (dateTagColor ?? cs.primary)
                    : (dateTagColor ??
                          cs.outlineVariant.withValues(alpha: 0.5));
                final plainDayTextStyle = theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w700,
                  color: isToday && !isSelected ? cs.primary : null,
                );
                final taggedDayTextStyle = theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w700,
                  color: isSelected
                      ? (dateTagColor ?? cs.primary)
                      : isToday
                      ? cs.primary
                      : null,
                );
                final tagTextStyle = theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      dateTagColor != null &&
                          dateTagColor.computeLuminance() > 0.5
                      ? Colors.black.withValues(alpha: 0.78)
                      : Colors.white.withValues(alpha: 0.94),
                );

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onDateSelected(dateKey),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: hasDateTag
                        ? const EdgeInsets.fromLTRB(2, 2, 2, 2)
                        : const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: hasDateTag
                        ? _TaggedCalendarDayCell(
                            day: day,
                            dateTagName: dateTagName,
                            dateTagColor: dateTagColor!,
                            dateTextStyle: taggedDayTextStyle,
                            tagTextStyle: tagTextStyle,
                            accentColors: accentColors,
                          )
                        : _PlainCalendarDayCell(
                            day: day,
                            dateTextStyle: plainDayTextStyle,
                            accentColors: accentColors,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlainCalendarDayCell extends StatelessWidget {
  const _PlainCalendarDayCell({
    required this.day,
    required this.dateTextStyle,
    required this.accentColors,
  });

  final DateTime day;
  final TextStyle? dateTextStyle;
  final List<Color> accentColors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          key: _calendarDayLabelKey(day),
          '${day.day}',
          style: dateTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        if (accentColors.isNotEmpty) _TaskDots(accentColors: accentColors),
      ],
    );
  }
}

class _TaggedCalendarDayCell extends StatelessWidget {
  const _TaggedCalendarDayCell({
    required this.day,
    required this.dateTagName,
    required this.dateTagColor,
    required this.dateTextStyle,
    required this.tagTextStyle,
    required this.accentColors,
  });

  final DateTime day;
  final String dateTagName;
  final Color dateTagColor;
  final TextStyle? dateTextStyle;
  final TextStyle? tagTextStyle;
  final List<Color> accentColors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 4),
          child: Row(
            children: [
              if (accentColors.isNotEmpty)
                _TaskDots(accentColors: accentColors),
              const Spacer(),
              Text(
                key: _calendarDayLabelKey(day),
                '${day.day}',
                style: dateTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: dateTagColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: AutoSizeText(
                    dateTagName,
                    style: tagTextStyle,
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskDots extends StatelessWidget {
  const _TaskDots({required this.accentColors});

  final List<Color> accentColors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: accentColors
          .map(
            (color) => Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          )
          .toList(),
    );
  }
}
