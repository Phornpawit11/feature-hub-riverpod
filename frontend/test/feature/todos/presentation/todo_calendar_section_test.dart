import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_calendar_section.dart';

void main() {
  Widget buildSubject({
    String? backgroundImagePath,
    bool isBackgroundImagePickerSupported = false,
    VoidCallback? onPickBackgroundImage,
    VoidCallback? onClearBackgroundImage,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            TodoCalendarSection(
              todos: const [],
              focusedMonth: DateTime(2026, 4),
              selectedDate: DateTime(2026, 4, 10),
              dateTagsByDay: const {},
              onMonthChanged: (_) {},
              onDateSelected: (_) {},
              onAddTag: () {},
              onChangeTag: () {},
              onRemoveTag: () {},
              onEdit: (_) {},
              onToggle: (_) {},
              onDelete: (_) {},
              backgroundImagePath: backgroundImagePath,
              isBackgroundImagePickerSupported: isBackgroundImagePickerSupported,
              onPickBackgroundImage: onPickBackgroundImage,
              onClearBackgroundImage: onClearBackgroundImage,
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('uses default card background when no image is selected', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    expect(find.byKey(const ValueKey('todo-calendar-card')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('calendar-background-image')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('calendar-background-clear-button')),
      findsNothing,
    );
  });

  testWidgets('renders image layer and action buttons when image is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        backgroundImagePath: '/tmp/fake-calendar-background.jpg',
        isBackgroundImagePickerSupported: true,
        onPickBackgroundImage: () {},
        onClearBackgroundImage: () {},
      ),
    );

    expect(
      find.byKey(const ValueKey('calendar-background-image')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('calendar-background-pick-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('calendar-background-clear-button')),
      findsOneWidget,
    );
  });

  testWidgets('disables gallery picker button on unsupported platforms', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    final pickButton = tester.widget<IconButton>(
      find.byKey(const ValueKey('calendar-background-pick-button')),
    );

    expect(pickButton.onPressed, isNull);
  });
}
