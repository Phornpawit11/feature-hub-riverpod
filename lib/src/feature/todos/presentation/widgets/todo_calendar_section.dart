import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_empty_state.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_tile.dart';

class TodoCalendarSection extends StatelessWidget {
  const TodoCalendarSection({
    super.key,
    required this.todos,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onMonthChanged,
    required this.onDateSelected,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Todo> todos;
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dueTodos.isEmpty)
          const TodoEmptyState(
            title: 'No due dates',
            subtitle: 'Add a due date to a task to see it on the calendar.',
          )
        else ...[
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
            todosByDay: groupedTodos,
            onDateSelected: onDateSelected,
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
          if (selectedTodos.isEmpty)
            Center(
              child: const TodoEmptyState(
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
    required this.todosByDay,
    required this.onDateSelected,
  });

  final List<DateTime?> monthDays;
  final DateTime selectedDate;
  final Map<DateTime, List<Todo>> todosByDay;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
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
          GridView.builder(
            itemCount: monthDays.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final day = monthDays[index];
              if (day == null) {
                return const SizedBox.shrink();
              }

              final dateKey = dateOnly(day);
              final isSelected = dateKey == dateOnly(selectedDate);
              final todos = todosByDay[dateKey] ?? const <Todo>[];
              final accentColors = todos
                  .map(
                    (todo) =>
                        parseTodoColor(todo.colorValue) ??
                        priorityColor(todo.priority),
                  )
                  .take(3)
                  .toList();

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onDateSelected(dateKey),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cs.primary.withValues(alpha: 0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? cs.primary
                          : cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${day.day}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (todos.isNotEmpty)
                        Wrap(
                          spacing: 3,
                          runSpacing: 3,
                          children: accentColors
                              .map(
                                (color) => Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
