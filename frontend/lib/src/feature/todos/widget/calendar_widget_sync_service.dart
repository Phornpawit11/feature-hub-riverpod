import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/date_tag_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/todo_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag_repository.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/todo_route_params.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';
import 'package:todos_riverpod/src/feature/todos/widget/calendar_widget_snapshot.dart';

const int calendarWidgetSchemaVersion = 1;
const String calendarWidgetChannelName =
    'todos_riverpod/calendar_widget_bridge';

abstract class CalendarWidgetSnapshotWriter {
  Future<void> writeSnapshot(CalendarWidgetSnapshot snapshot);
}

class MethodChannelCalendarWidgetSnapshotWriter
    implements CalendarWidgetSnapshotWriter {
  const MethodChannelCalendarWidgetSnapshotWriter();

  static const MethodChannel _channel = MethodChannel(
    calendarWidgetChannelName,
  );

  @override
  Future<void> writeSnapshot(CalendarWidgetSnapshot snapshot) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    await _channel.invokeMethod<void>('saveCalendarWidgetSnapshot', <String, dynamic>{
      'snapshotJson': jsonEncode(snapshot.toJson()),
      'schemaVersion': snapshot.schemaVersion,
      'updatedAtMillis': DateTime.now().millisecondsSinceEpoch,
    });
  }
}

class CalendarWidgetSyncService {
  CalendarWidgetSyncService({
    required TodoRepository todoRepository,
    required DateTagRepository dateTagRepository,
    required CalendarWidgetSnapshotWriter writer,
    DateTime Function()? now,
    Duration debounceDuration = const Duration(milliseconds: 350),
  }) : _todoRepository = todoRepository,
       _dateTagRepository = dateTagRepository,
       _writer = writer,
       _now = now ?? DateTime.now,
       _debounceDuration = debounceDuration;

  final TodoRepository _todoRepository;
  final DateTagRepository _dateTagRepository;
  final CalendarWidgetSnapshotWriter _writer;
  final DateTime Function() _now;
  final Duration _debounceDuration;

  Timer? _pendingTimer;

  Future<CalendarWidgetSnapshot> buildCalendarWidgetSnapshot({
    DateTime? month,
    DateTime? selectedDate,
  }) async {
    final now = normalizeDate(_now());
    final normalizedSelectedDate = normalizeDate(selectedDate ?? now);
    final focusedMonth = DateTime(
      (month ?? normalizedSelectedDate).year,
      (month ?? normalizedSelectedDate).month,
    );

    final todos = await _todoRepository.getTodos();
    final tags = await _dateTagRepository.getDateTags();
    final taggedDates = await _dateTagRepository.getTaggedDates();

    final todosByDay = <DateTime, List<Todo>>{};
    for (final Todo todo in todos) {
      final dueDate = todo.dueDate;
      if (dueDate == null) {
        continue;
      }

      final dayKey = normalizeDate(dueDate);
      todosByDay.putIfAbsent(dayKey, () => <Todo>[]).add(todo);
    }

    final tagsById = <String, DateTag>{
      for (final DateTag tag in tags) tag.id: tag,
    };
    final tagIdByDay = <DateTime, String>{
      for (final TaggedDate taggedDate in taggedDates)
        normalizeDate(taggedDate.date): taggedDate.tagId,
    };

    final days = buildMonthGridDates(focusedMonth).map((DateTime day) {
      final tag = tagsById[tagIdByDay[day]];
      final routeParams = TodoRouteParams(
        focusedMonth: focusedMonth,
        selectedDate: day,
      );
      final todoDotColors = (todosByDay[day] ?? const <Todo>[])
          .map(_todoAccentColorHex)
          .take(3)
          .toList(growable: false);

      return CalendarWidgetDaySnapshot(
        date: _formatDate(day),
        isToday: day == now,
        isCurrentMonth: day.month == focusedMonth.month && day.year == focusedMonth.year,
        tagColor: tag == null ? null : _normalizeColorHex(tag.colorValue),
        tagLabel: tag?.name.trim(),
        tagLabelShort: tag == null ? null : _buildTagLabelShort(tag.name),
        todoDotColors: todoDotColors,
        deepLinkTarget: routeParams.toWidgetUri().toString(),
      );
    }).toList(growable: false);

    return CalendarWidgetSnapshot(
      schemaVersion: calendarWidgetSchemaVersion,
      year: focusedMonth.year,
      month: focusedMonth.month,
      selectedDate: _formatDate(normalizedSelectedDate),
      defaultDeepLinkTarget: TodoRouteParams(
        focusedMonth: focusedMonth,
        selectedDate: normalizedSelectedDate,
      ).toWidgetUri().toString(),
      days: days,
    );
  }

  Future<void> syncCalendarWidgetSnapshot({
    DateTime? month,
    DateTime? selectedDate,
  }) async {
    final snapshot = await buildCalendarWidgetSnapshot(
      month: month,
      selectedDate: selectedDate,
    );
    await _writer.writeSnapshot(snapshot);
  }

  void scheduleSyncCalendarWidgetSnapshot({
    DateTime? month,
    DateTime? selectedDate,
  }) {
    _pendingTimer?.cancel();
    _pendingTimer = Timer(_debounceDuration, () async {
      try {
        await syncCalendarWidgetSnapshot(
          month: month,
          selectedDate: selectedDate,
        );
      } catch (_) {
        // Keep the last successful snapshot if a refresh fails.
      }
    });
  }

  void dispose() {
    _pendingTimer?.cancel();
  }

  static String _buildTagLabelShort(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words.first[0]}${words.last[0]}'.toUpperCase();
    }

    return trimmed.substring(0, min(2, trimmed.length)).toUpperCase();
  }

  static String _todoAccentColorHex(Todo todo) {
    final parsed = _normalizeColorHex(todo.colorValue);
    if (parsed != null) {
      return parsed;
    }

    return _colorToHex(priorityColor(todo.priority));
  }

  static String _colorToHex(Color color) {
    return color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  static String _formatDate(DateTime date) {
    final normalized = normalizeDate(date);
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String? _normalizeColorHex(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final sanitized = value.trim().replaceFirst('#', '').toUpperCase();
    if (sanitized.length == 6) {
      return 'FF$sanitized';
    }

    if (sanitized.length == 8) {
      return sanitized;
    }

    return null;
  }
}

List<DateTime> buildMonthGridDates(DateTime focusedMonth) {
  final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
  final leadingDays = firstDay.weekday - 1;
  final startDate = firstDay.subtract(Duration(days: leadingDays));
  final daysInMonth = DateTime(
    focusedMonth.year,
    focusedMonth.month + 1,
    0,
  ).day;
  final totalSlots = ((leadingDays + daysInMonth) / 7).ceil() * 7;

  return List<DateTime>.generate(totalSlots, (int index) {
    final date = startDate.add(Duration(days: index));
    return normalizeDate(date);
  });
}

final calendarWidgetSnapshotWriterProvider = Provider<CalendarWidgetSnapshotWriter>(
  (Ref ref) => const MethodChannelCalendarWidgetSnapshotWriter(),
);

final calendarWidgetSyncServiceProvider = Provider<CalendarWidgetSyncService>((
  Ref ref,
) {
  final service = CalendarWidgetSyncService(
    todoRepository: ref.read(todoRepositoryProvider),
    dateTagRepository: ref.read(dateTagRepositoryProvider),
    writer: ref.read(calendarWidgetSnapshotWriterProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final calendarWidgetStartupSyncProvider = FutureProvider<void>((Ref ref) async {
  await ref.read(calendarWidgetSyncServiceProvider).syncCalendarWidgetSnapshot();
});
