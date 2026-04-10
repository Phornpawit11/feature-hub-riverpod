import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/todo_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/date_tag_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag_repository.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo_repository.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/todo.screen.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';

void main() {
  group('TodoScreen date tags', () {
    testWidgets('can assign an existing tag to the selected day', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(
        tags: [DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF')],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await _scrollToTagSection(tester);
      await tester.tap(find.text('Add tag'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();

      expect(find.text('Work'), findsAtLeastNWidgets(1));
      expect(dateTagRepository.taggedDates, hasLength(1));
    });

    testWidgets('can create and apply a new tag from the sheet', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Review roadmap',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(tags: const []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await _scrollToTagSection(tester);
      await tester.tap(find.text('Add tag'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Study');
      await tester.tap(find.text('Save tag and apply'));
      await tester.pumpAndSettle();

      expect(find.text('Study'), findsAtLeastNWidgets(1));
      expect(dateTagRepository.tags.single.name, 'Study');
      expect(dateTagRepository.taggedDates, hasLength(1));
    });

    testWidgets('can remove an assigned tag from the selected day', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(
        tags: [DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF')],
        taggedDates: [
          TaggedDate(id: dateStorageKey(today), date: today, tagId: 'work'),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await _scrollToTagSection(tester);
      expect(find.text('Work'), findsAtLeastNWidgets(1));
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(find.text('Add tag'), findsOneWidget);
      expect(dateTagRepository.taggedDates, isEmpty);
    });

    testWidgets('can edit an existing tag from the sheet', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Review roadmap',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(
        tags: [DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF')],
        taggedDates: [
          TaggedDate(id: dateStorageKey(today), date: today, tagId: 'work'),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await _scrollToTagSection(tester);
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit Work'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Deep Work');
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(find.text('Deep Work'), findsWidgets);
      expect(dateTagRepository.tags.single.name, 'Deep Work');
    });

    testWidgets('can delete a global tag from the management sheet', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Review roadmap',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(
        tags: [DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF')],
        taggedDates: [
          TaggedDate(id: dateStorageKey(today), date: today, tagId: 'work'),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await _scrollToTagSection(tester);
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit Work'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Edit Work'), findsNothing);
      expect(dateTagRepository.tags, isEmpty);
      expect(dateTagRepository.taggedDates, isEmpty);
    });

    testWidgets('swipe left on calendar grid goes to next month', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(tags: const []);
      final nextMonth = DateTime(today.year, today.month + 1);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(GridView).last);
      await tester.pumpAndSettle();
      await tester.fling(
        find.byType(GridView).last,
        const Offset(-500, 0),
        1200,
      );
      await tester.pumpAndSettle();

      expect(find.text(formatTodoMonth(nextMonth)), findsOneWidget);
      expect(
        find.text(
          'Due on ${formatTodoDate(DateTime(nextMonth.year, nextMonth.month))}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('swipe right on calendar grid goes to previous month', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(tags: const []);
      final previousMonth = DateTime(today.year, today.month - 1);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(GridView).last);
      await tester.pumpAndSettle();
      await tester.fling(
        find.byType(GridView).last,
        const Offset(500, 0),
        1200,
      );
      await tester.pumpAndSettle();

      expect(find.text(formatTodoMonth(previousMonth)), findsOneWidget);
      expect(
        find.text(
          'Due on ${formatTodoDate(DateTime(previousMonth.year, previousMonth.month))}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('swipe left on screen outside grid switches to list mode', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(tags: const []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final monthLabel = formatTodoMonth(today);
      final dueOnLabel = 'Due on ${formatTodoDate(today)}';

      expect(find.text(monthLabel), findsOneWidget);
      expect(find.text(dueOnLabel), findsOneWidget);

      await tester.fling(find.text(monthLabel), const Offset(-500, 0), 1200);
      await tester.pumpAndSettle();

      expect(find.text(monthLabel), findsNothing);
      expect(find.text(dueOnLabel), findsNothing);
      expect(find.text('Plan launch'), findsOneWidget);
    });

    testWidgets('swipe right on screen outside grid switches to list mode', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(tags: const []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final monthLabel = formatTodoMonth(today);
      final dueOnLabel = 'Due on ${formatTodoDate(today)}';

      expect(find.text(monthLabel), findsOneWidget);
      expect(find.text(dueOnLabel), findsOneWidget);

      await tester.fling(find.text(monthLabel), const Offset(500, 0), 1200);
      await tester.pumpAndSettle();

      expect(find.text(monthLabel), findsNothing);
      expect(find.text(dueOnLabel), findsNothing);
      expect(find.text('Plan launch'), findsOneWidget);
    });

    testWidgets('swipe left in list mode switches back to calendar mode', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(tags: const []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final monthLabel = formatTodoMonth(today);
      final dueOnLabel = 'Due on ${formatTodoDate(today)}';

      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      expect(find.text(monthLabel), findsNothing);
      expect(find.text(dueOnLabel), findsNothing);

      await tester.fling(find.text('Plan launch'), const Offset(-500, 0), 1200);
      await tester.pumpAndSettle();

      expect(find.text(monthLabel), findsOneWidget);
      expect(find.text(dueOnLabel), findsOneWidget);
    });

    testWidgets('swipe right in list mode switches back to calendar mode', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(tags: const []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoRepositoryProvider.overrideWithValue(todoRepository),
            dateTagRepositoryProvider.overrideWithValue(dateTagRepository),
          ],
          child: const MaterialApp(home: TodoScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final monthLabel = formatTodoMonth(today);
      final dueOnLabel = 'Due on ${formatTodoDate(today)}';

      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      expect(find.text(monthLabel), findsNothing);
      expect(find.text(dueOnLabel), findsNothing);

      await tester.fling(find.text('Plan launch'), const Offset(500, 0), 1200);
      await tester.pumpAndSettle();

      expect(find.text(monthLabel), findsOneWidget);
      expect(find.text(dueOnLabel), findsOneWidget);
    });
  });
}

Future<void> _scrollToTagSection(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Tag'),
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

class _FakeTodoRepository implements TodoRepository {
  _FakeTodoRepository({required List<Todo> todos}) : _todos = List.of(todos);

  final List<Todo> _todos;

  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    _todos.removeWhere((todo) => todo.id == todoId);
  }

  @override
  Future<void> editTodo(
    String todoId, {
    required String title,
    required TodoPriority priority,
    DateTime? dueDate,
    String? colorValue,
  }) async {
    final index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index == -1) return;
    _todos[index] = _todos[index].copyWith(
      title: title,
      priority: priority,
      dueDate: dueDate,
      colorValue: colorValue,
    );
  }

  @override
  Future<List<Todo>> getTodos() async {
    return List.unmodifiable(_todos);
  }

  @override
  Future<void> toggleTodo(String todoId) async {
    final index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index == -1) return;
    _todos[index] = _todos[index].copyWith(
      isCompleted: !_todos[index].isCompleted,
    );
  }
}

class _FakeDateTagRepository implements DateTagRepository {
  _FakeDateTagRepository({
    required List<DateTag> tags,
    List<TaggedDate>? taggedDates,
  }) : tags = List.of(tags),
       taggedDates = List.of(taggedDates ?? const []);

  final List<DateTag> tags;
  final List<TaggedDate> taggedDates;

  @override
  Future<void> assignTagToDate(DateTime date, String tagId) async {
    final normalizedDate = normalizeDate(date);
    taggedDates.removeWhere(
      (entry) => entry.id == dateStorageKey(normalizedDate),
    );
    taggedDates.add(
      TaggedDate(
        id: dateStorageKey(normalizedDate),
        date: normalizedDate,
        tagId: tagId,
      ),
    );
  }

  @override
  Future<void> createTag(DateTag tag) async {
    tags.add(tag);
  }

  @override
  Future<void> deleteTag(String tagId) async {
    tags.removeWhere((tag) => tag.id == tagId);
    taggedDates.removeWhere((taggedDate) => taggedDate.tagId == tagId);
  }

  @override
  Future<List<DateTag>> getDateTags() async {
    return List.unmodifiable(tags);
  }

  @override
  Future<List<TaggedDate>> getTaggedDates() async {
    return List.unmodifiable(taggedDates);
  }

  @override
  Future<void> removeTagFromDate(DateTime date) async {
    taggedDates.removeWhere((entry) => entry.id == dateStorageKey(date));
  }

  @override
  Future<void> updateTag(DateTag tag) async {
    final index = tags.indexWhere((existing) => existing.id == tag.id);
    if (index == -1) return;
    tags[index] = tag;
  }
}
