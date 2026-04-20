import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';

const List<String> todoWeekdayLabels = <String>[
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

const List<String?> todoColors = <String?>[
  null,
  'FF5B8DEF',
  'FF26A69A',
  'FFFFB020',
  'FFEF5350',
  'FFAB47BC',
  'FF8D6E63',
  'FF3F51B5',
  'FF00ACC1',
  'FF7CB342',
  'FFF4511E',
  'FFD81B60',
  'FF546E7A',
];

DateTime dateOnly(DateTime date) => normalizeDate(date);

List<DateTime?> buildMonthDays(DateTime focusedMonth) {
  final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
  final daysInMonth = DateTime(
    focusedMonth.year,
    focusedMonth.month + 1,
    0,
  ).day;

  final leadingEmptySlots = firstDay.weekday - 1;
  final totalSlots = ((leadingEmptySlots + daysInMonth) / 7).ceil() * 7;

  return List<DateTime?>.generate(totalSlots, (index) {
    final dayOffset = index - leadingEmptySlots + 1;
    if (dayOffset <= 0 || dayOffset > daysInMonth) {
      return null;
    }

    return DateTime(focusedMonth.year, focusedMonth.month, dayOffset);
  });
}

String formatTodoDate(DateTime date) {
  final month = switch (date.month) {
    1 => 'Jan',
    2 => 'Feb',
    3 => 'Mar',
    4 => 'Apr',
    5 => 'May',
    6 => 'Jun',
    7 => 'Jul',
    8 => 'Aug',
    9 => 'Sep',
    10 => 'Oct',
    11 => 'Nov',
    _ => 'Dec',
  };

  return '${date.day} $month ${date.year}';
}

String formatTodoMonth(DateTime date) {
  final month = switch (date.month) {
    1 => 'January',
    2 => 'February',
    3 => 'March',
    4 => 'April',
    5 => 'May',
    6 => 'June',
    7 => 'July',
    8 => 'August',
    9 => 'September',
    10 => 'October',
    11 => 'November',
    _ => 'December',
  };

  return '$month ${date.year}';
}

Color priorityColor(TodoPriority priority) => switch (priority) {
  TodoPriority.low => const Color(0xFF26A69A),
  TodoPriority.medium => const Color(0xFFFFB020),
  TodoPriority.high => const Color(0xFFEF5350),
};

Color? parseTodoColor(String? value) {
  if (value == null) return null;
  final parsed = int.tryParse(value, radix: 16);
  if (parsed == null) return null;
  return Color(parsed);
}

Color foregroundColorForBackground(Color backgroundColor) {
  return backgroundColor.computeLuminance() > 0.5
      ? Colors.black.withValues(alpha: 0.78)
      : Colors.white.withValues(alpha: 0.94);
}
