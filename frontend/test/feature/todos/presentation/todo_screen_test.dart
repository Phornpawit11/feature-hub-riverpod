import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/todo.screen.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/calendar_background_usecase.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_state.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_usecase.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/todo.usecase.dart';

void main() {
  // ─── helpers ───────────────────────────────────────────────────────────────

  Widget buildSubject({
    _FakeTodoUsecase? todoNotifier,
    _FakeDateTagUsecase? dateTagNotifier,
    _FakeCalendarBackgroundUsecase? calendarBackgroundNotifier,
  }) {
    final todo = todoNotifier ?? _FakeTodoUsecase(todos: []);
    final dateTag = dateTagNotifier ?? _FakeDateTagUsecase();
    final calendarBackground =
        calendarBackgroundNotifier ?? _FakeCalendarBackgroundUsecase();
    return ProviderScope(
      overrides: [
        todoUsecaseProvider.overrideWith(() => todo),
        dateTagUsecaseProvider.overrideWith(() => dateTag),
        calendarBackgroundUsecaseProvider.overrideWith(
          () => calendarBackground,
        ),
      ],
      child: const MaterialApp(home: TodoScreen()),
    );
  }

  // ─── Delete confirmation ────────────────────────────────────────────────────

  group('delete confirmation dialog', () {
    testWidgets('shows confirmation dialog before deleting', (tester) async {
      final todoNotifier = _FakeTodoUsecase(todos: [_todo()]);

      await tester.pumpWidget(buildSubject(todoNotifier: todoNotifier));
      await tester.pumpAndSettle();

      // สลับเป็น list view
      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      // เปิด overflow menu
      await tester.tap(find.byIcon(Icons.more_horiz_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // dialog ต้องปรากฏ
      expect(find.text('Delete task?'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);
    });

    testWidgets('cancelling dialog does not delete todo', (tester) async {
      final todoNotifier = _FakeTodoUsecase(todos: [_todo()]);

      await tester.pumpWidget(buildSubject(todoNotifier: todoNotifier));
      await tester.pumpAndSettle();

      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_horiz_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // กด Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(todoNotifier.deletedIds, isEmpty);
    });

    testWidgets('confirming dialog calls deleteTodo', (tester) async {
      final todoNotifier = _FakeTodoUsecase(todos: [_todo()]);

      await tester.pumpWidget(buildSubject(todoNotifier: todoNotifier));
      await tester.pumpAndSettle();

      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_horiz_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // กด Delete ใน dialog
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();

      expect(todoNotifier.deletedIds, ['todo-1']);
    });
  });

  // ─── Error state & retry ───────────────────────────────────────────────────

  group('error state', () {
    testWidgets('shows "Something went wrong" and Retry when todos error', (
      tester,
    ) async {
      final todoNotifier = _FakeTodoUsecase(throwError: true);

      await tester.pumpWidget(buildSubject(todoNotifier: todoNotifier));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('Retry button rebuilds todo provider', (tester) async {
      final todoNotifier = _FakeTodoUsecase(throwError: true);

      await tester.pumpWidget(buildSubject(todoNotifier: todoNotifier));
      await tester.pumpAndSettle();

      // tap Retry
      todoNotifier.throwError = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // error ควรหายไปหลัง retry
      expect(find.text('Something went wrong'), findsNothing);
    });
  });
}

// ─── Fakes ──────────────────────────────────────────────────────────────────

Todo _todo() => Todo(
  id: 'todo-1',
  title: 'Test task',
  createdAt: DateTime(2026, 4, 10),
  isCompleted: false,
  priority: TodoPriority.medium,
);

class _FakeTodoUsecase extends TodoUsecase {
  _FakeTodoUsecase({List<Todo> todos = const [], this.throwError = false})
    : _todos = List.of(todos);

  final List<Todo> _todos;
  bool throwError;
  final List<String> deletedIds = [];
  final List<String> addedTitles = [];

  @override
  FutureOr<List<Todo>> build() {
    if (throwError) throw Exception('Load error');
    return List.unmodifiable(_todos);
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    deletedIds.add(todoId);
    _todos.removeWhere((t) => t.id == todoId);
    state = AsyncData(List.unmodifiable(_todos));
  }

  @override
  Future<void> addTodo({
    required String title,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
    String? colorValue,
  }) async {
    addedTitles.add(title);
  }

  @override
  Future<void> toggleTodo(String todoId) async {}

  @override
  Future<void> editTodo(
    String todoId, {
    required String title,
    required TodoPriority priority,
    DateTime? dueDate,
    String? colorValue,
  }) async {}
}

class _FakeDateTagUsecase extends DateTagUsecase {
  @override
  FutureOr<DateTagState> build() =>
      const DateTagState(tags: <DateTag>[], taggedDates: []);
}

class _FakeCalendarBackgroundUsecase extends CalendarBackgroundUsecase {
  _FakeCalendarBackgroundUsecase();

  String? imagePath;

  @override
  Future<String?> build() async => imagePath;

  @override
  Future<void> clearCalendarBackground() async {
    imagePath = null;
    state = const AsyncData<String?>(null);
  }

  @override
  Future<void> setCalendarBackground(String imagePath) async {
    this.imagePath = imagePath;
    state = AsyncData(imagePath);
  }
}
