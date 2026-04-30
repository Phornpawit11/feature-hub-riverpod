import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag_repository.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';
import 'package:todos_riverpod/src/feature/todos/widget/calendar_widget_snapshot.dart';
import 'package:todos_riverpod/src/feature/todos/widget/calendar_widget_sync_service.dart';

void main() {
  group('CalendarWidgetSyncService', () {
    test('builds a fixed month snapshot with tag colors and todo dots', () async {
      final service = CalendarWidgetSyncService(
        todoRepository: _FakeTodoRepository(
          todos: [
            Todo(
              id: 'todo-1',
              title: 'Plan launch',
              createdAt: DateTime(2026, 4),
              isCompleted: false,
              dueDate: DateTime(2026, 4, 10),
              colorValue: 'FF5B8DEF',
            ),
            Todo(
              id: 'todo-2',
              title: 'Review copy',
              createdAt: DateTime(2026, 4),
              isCompleted: false,
              dueDate: DateTime(2026, 4, 10),
              colorValue: 'FF26A69A',
            ),
            Todo(
              id: 'todo-3',
              title: 'Finalize pricing',
              createdAt: DateTime(2026, 4, 2),
              isCompleted: false,
              dueDate: DateTime(2026, 4, 10),
              colorValue: 'FFFFB020',
            ),
            Todo(
              id: 'todo-4',
              title: 'Ignored fourth dot',
              createdAt: DateTime(2026, 4, 2),
              isCompleted: false,
              dueDate: DateTime(2026, 4, 10),
              colorValue: 'FFEF5350',
            ),
          ],
        ),
        dateTagRepository: _FakeDateTagRepository(
          tags: [
            DateTag(id: 'work', name: 'Deep Work', colorValue: 'FF7C4DFF'),
          ],
          taggedDates: [
            TaggedDate(
              id: '2026-04-10',
              date: DateTime(2026, 4, 10),
              tagId: 'work',
            ),
          ],
        ),
        writer: _FakeCalendarWidgetSnapshotWriter(),
        now: () => DateTime(2026, 4, 10, 8),
      );

      final snapshot = await service.buildCalendarWidgetSnapshot(
        month: DateTime(2026, 4),
        selectedDate: DateTime(2026, 4, 10),
      );

      expect(snapshot.schemaVersion, calendarWidgetSchemaVersion);
      expect(snapshot.year, 2026);
      expect(snapshot.month, 4);
      expect(snapshot.selectedDate, '2026-04-10');
      expect(snapshot.days, hasLength(35));

      final selectedDay = snapshot.days.firstWhere(
        (day) => day.date == '2026-04-10',
      );
      expect(selectedDay.isToday, isTrue);
      expect(selectedDay.isCurrentMonth, isTrue);
      expect(selectedDay.tagColor, 'FF7C4DFF');
      expect(selectedDay.tagLabel, 'Deep Work');
      expect(selectedDay.tagLabelShort, 'DW');
      expect(
        selectedDay.todoDotColors,
        ['FF5B8DEF', 'FF26A69A', 'FFFFB020'],
      );
      expect(
        selectedDay.deepLinkTarget,
        contains('selectedDate=2026-04-10'),
      );

      final leadingDay = snapshot.days.first;
      expect(leadingDay.date, '2026-03-30');
      expect(leadingDay.isCurrentMonth, isFalse);
    });

    test('coalesces scheduled syncs and keeps only the latest write', () async {
      final writer = _FakeCalendarWidgetSnapshotWriter();
      final service = CalendarWidgetSyncService(
        todoRepository: _FakeTodoRepository(todos: const []),
        dateTagRepository: _FakeDateTagRepository(tags: const [], taggedDates: const []),
        writer: writer,
        now: () => DateTime(2026, 4, 10, 8),
        debounceDuration: const Duration(milliseconds: 10),
      );

      service.scheduleSyncCalendarWidgetSnapshot(
        selectedDate: DateTime(2026, 4, 10),
      );
      service.scheduleSyncCalendarWidgetSnapshot(
        selectedDate: DateTime(2026, 4, 11),
      );

      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(writer.snapshots, hasLength(1));
      expect(writer.snapshots.single.selectedDate, '2026-04-11');
    });
  });
}

class _FakeCalendarWidgetSnapshotWriter
    implements CalendarWidgetSnapshotWriter {
  final List<CalendarWidgetSnapshot> snapshots = <CalendarWidgetSnapshot>[];

  @override
  Future<void> writeSnapshot(CalendarWidgetSnapshot snapshot) async {
    snapshots.add(snapshot);
  }
}

class _FakeTodoRepository implements TodoRepository {
  _FakeTodoRepository({required List<Todo> todos}) : _todos = List.of(todos);

  final List<Todo> _todos;

  @override
  Future<void> addTodo(Todo todo) async {}

  @override
  Future<void> deleteTodo(String todoId) async {}

  @override
  Future<void> editTodo(
    String todoId, {
    required String title,
    required TodoPriority priority,
    DateTime? dueDate,
    String? colorValue,
  }) async {}

  @override
  Future<List<Todo>> getTodos() async {
    return List<Todo>.unmodifiable(_todos);
  }

  @override
  Future<void> toggleTodo(String todoId) async {}
}

class _FakeDateTagRepository implements DateTagRepository {
  _FakeDateTagRepository({
    required List<DateTag> tags,
    required List<TaggedDate> taggedDates,
  }) : _tags = List.of(tags),
       _taggedDates = List.of(taggedDates);

  final List<DateTag> _tags;
  final List<TaggedDate> _taggedDates;

  @override
  Future<void> assignTagToDate(DateTime date, String tagId) async {}

  @override
  Future<void> createTag(DateTag tag) async {}

  @override
  Future<void> deleteTag(String tagId) async {}

  @override
  Future<List<DateTag>> getDateTags() async {
    return List<DateTag>.unmodifiable(_tags);
  }

  @override
  Future<List<TaggedDate>> getTaggedDates() async {
    return List<TaggedDate>.unmodifiable(_taggedDates);
  }

  @override
  Future<void> removeTagFromDate(DateTime date) async {}

  @override
  Future<void> updateTag(DateTag tag) async {}
}
