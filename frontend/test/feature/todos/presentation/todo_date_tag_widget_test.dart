import 'package:auto_size_text/auto_size_text.dart';
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
    testWidgets(
      'assigning an existing tag keeps sheet open and advances date',
      (WidgetTester tester) async {
        final today = normalizeDate(DateTime.now());
        final tomorrow = normalizeDate(today.add(const Duration(days: 1)));
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

        expect(find.text('Assign a tag'), findsOneWidget);
        expect(find.text(formatTodoDate(tomorrow)), findsWidgets);
        expect(dateTagRepository.taggedDates, hasLength(1));
      },
    );

    testWidgets('creating a new tag keeps sheet open without advancing date', (
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
      expect(find.text('Save'), findsNothing);
      await tester.tap(find.text('Create new tag'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Study');
      await tester.ensureVisible(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Assign a tag'), findsOneWidget);
      expect(find.text(formatTodoDate(today)), findsWidgets);
      expect(find.text('Study'), findsWidgets);
      expect(dateTagRepository.tags.single.name, 'Study');
      expect(dateTagRepository.taggedDates, isEmpty);
    });

    testWidgets('create tag form starts collapsed and expands on demand', (
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

      expect(find.text('Create new tag'), findsOneWidget);
      expect(find.text('Save'), findsNothing);

      await tester.tap(find.text('Create new tag'));
      await tester.pumpAndSettle();

      expect(find.text('Tag details'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('existing tags render as a four-column grid', (
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
        tags: List.generate(
          5,
          (index) => DateTag(
            id: 'tag-$index',
            name: 'Tag ${index + 1}',
            colorValue: 'FF5B8DEF',
          ),
        ),
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

      final tag1 = tester.getTopLeft(find.text('Tag 1').first);
      final tag2 = tester.getTopLeft(find.text('Tag 2').first);
      final tag3 = tester.getTopLeft(find.text('Tag 3').first);
      final tag4 = tester.getTopLeft(find.text('Tag 4').first);
      final tag5 = tester.getTopLeft(find.text('Tag 5').first);

      expect(tag2.dx, greaterThan(tag1.dx));
      expect(tag3.dx, greaterThan(tag2.dx));
      expect(tag4.dx, greaterThan(tag3.dx));
      expect((tag1.dy - tag4.dy).abs(), lessThan(8));
      expect(tag5.dy, greaterThan(tag1.dy + 20));
    });

    testWidgets('today uses emphasized number styling when selected', (
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

      final style = _calendarDayLabelStyle(tester, today);
      expect(style?.fontWeight, FontWeight.w800);
    });

    testWidgets('today keeps highlighted number styling when not selected', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final alternateDay = _alternateDayInSameMonth(today);
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

      await tester.ensureVisible(find.text('${alternateDay.day}').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('${alternateDay.day}').last);
      await tester.pumpAndSettle();

      final style = _calendarDayLabelStyle(tester, today);
      final primary = Theme.of(
        tester.element(find.byType(TodoScreen)),
      ).colorScheme.primary;

      expect(style?.fontWeight, FontWeight.w800);
      expect(style?.color, primary);
    });

    testWidgets('today with a tag still uses emphasized number styling', (
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

      final style = _calendarDayLabelStyle(tester, today);

      expect(style?.fontWeight, FontWeight.w800);
      expect(find.text('Work'), findsWidgets);
    });

    testWidgets('a saved tag can be selected from the row and then applied', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final tomorrow = normalizeDate(today.add(const Duration(days: 1)));
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
      await tester.tap(find.text('Create new tag'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Study');
      await tester.ensureVisible(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(dateTagRepository.tags.single.name, 'Study');
      expect(dateTagRepository.taggedDates, isEmpty);

      await tester.tap(find.text('Study').first);
      await tester.pumpAndSettle();

      expect(dateTagRepository.taggedDates, hasLength(1));
      expect(find.text(formatTodoDate(tomorrow)), findsWidgets);
    });

    testWidgets('assigning from the last day of month moves to next month', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final lastDayOfMonth = normalizeDate(
        DateTime(today.year, today.month + 1, 0),
      );
      final firstDayOfNextMonth = normalizeDate(
        DateTime(today.year, today.month + 1, 1),
      );
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Month end review',
            createdAt: today,
            isCompleted: false,
            dueDate: lastDayOfMonth,
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

      await tester.scrollUntilVisible(
        find.text('${lastDayOfMonth.day}'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('${lastDayOfMonth.day}'));
      await tester.pumpAndSettle();
      await _scrollToTagSection(tester);
      await tester.tap(find.text('Add tag'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();

      expect(find.text(formatTodoMonth(firstDayOfNextMonth)), findsOneWidget);
      expect(find.text(formatTodoDate(firstDayOfNextMonth)), findsWidgets);
      expect(find.text('Assign a tag'), findsOneWidget);
    });

    testWidgets('next day with an assigned tag stays in sheet and shows it', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final tomorrow = normalizeDate(today.add(const Duration(days: 1)));
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
        tags: [
          DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF'),
          DateTag(id: 'personal', name: 'Personal', colorValue: 'FF26A69A'),
        ],
        taggedDates: [
          TaggedDate(
            id: dateStorageKey(tomorrow),
            date: tomorrow,
            tagId: 'personal',
          ),
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
      await tester.tap(find.text('Add tag'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();

      expect(find.text('Assign a tag'), findsOneWidget);
      expect(find.text('Current tag'), findsOneWidget);
      expect(find.text(formatTodoDate(tomorrow)), findsWidgets);
      expect(find.text('Personal'), findsWidgets);
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

    testWidgets('remove focuses the previous tagged date in the same month', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final previousTaggedDate = normalizeDate(
        today.subtract(const Duration(days: 2)),
      );
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
          Todo(
            id: '2',
            title: 'Review launch',
            createdAt: today,
            isCompleted: false,
            dueDate: previousTaggedDate,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(
        tags: [
          DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF'),
          DateTag(id: 'study', name: 'Study', colorValue: 'FF7CB342'),
        ],
        taggedDates: [
          TaggedDate(id: dateStorageKey(today), date: today, tagId: 'work'),
          TaggedDate(
            id: dateStorageKey(previousTaggedDate),
            date: previousTaggedDate,
            tagId: 'study',
          ),
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
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(
        find.text('Due on ${formatTodoDate(previousTaggedDate)}'),
        findsOne,
      );
      expect(find.text('Study'), findsWidgets);
      expect(dateTagRepository.taggedDates, hasLength(1));
    });

    testWidgets('remove falls back to next tagged date in the same month', (
      WidgetTester tester,
    ) async {
      final today = normalizeDate(DateTime.now());
      final nextTaggedDate = normalizeDate(today.add(const Duration(days: 2)));
      final todoRepository = _FakeTodoRepository(
        todos: [
          Todo(
            id: '1',
            title: 'Plan launch',
            createdAt: today,
            isCompleted: false,
            dueDate: nextTaggedDate,
          ),
          Todo(
            id: '2',
            title: 'Review launch',
            createdAt: today,
            isCompleted: false,
            dueDate: today,
          ),
        ],
      );
      final dateTagRepository = _FakeDateTagRepository(
        tags: [
          DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF'),
          DateTag(id: 'study', name: 'Study', colorValue: 'FF7CB342'),
        ],
        taggedDates: [
          TaggedDate(
            id: dateStorageKey(nextTaggedDate),
            date: nextTaggedDate,
            tagId: 'study',
          ),
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

      await tester.ensureVisible(find.text('${today.day}').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('${today.day}').last);
      await tester.pumpAndSettle();
      await _scrollToTagSection(tester);
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(find.text('Due on ${formatTodoDate(nextTaggedDate)}'), findsOne);
      expect(find.text('Study'), findsWidgets);
      expect(find.text(formatTodoMonth(today)), findsOneWidget);
      expect(dateTagRepository.taggedDates, hasLength(1));
    });

    testWidgets(
      'remove keeps the same selected date when no tagged dates remain',
      (WidgetTester tester) async {
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
        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();

        expect(find.text('Due on ${formatTodoDate(today)}'), findsOneWidget);
        expect(find.text('Add tag'), findsOneWidget);
        expect(dateTagRepository.taggedDates, isEmpty);
      },
    );

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

DateTime _alternateDayInSameMonth(DateTime today) {
  final nextDay = normalizeDate(today.add(const Duration(days: 1)));
  if (nextDay.month == today.month) {
    return nextDay;
  }

  return normalizeDate(today.subtract(const Duration(days: 1)));
}

TextStyle? _calendarDayLabelStyle(WidgetTester tester, DateTime day) {
  final widget = tester.widget(
    find.byKey(
      ValueKey('calendar-day-label-${day.year}-${day.month}-${day.day}'),
    ),
  );

  if (widget is AutoSizeText) {
    return widget.style;
  }

  if (widget is Text) {
    return widget.style;
  }

  return null;
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
