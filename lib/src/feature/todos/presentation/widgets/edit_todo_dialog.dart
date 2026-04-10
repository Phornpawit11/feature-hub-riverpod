import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_editor_fields.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/todo.usecase.dart';

class EditTodoDialog extends HookConsumerWidget {
  const EditTodoDialog({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editController = useTextEditingController(text: todo.title);
    final selectedPriority = useState(todo.priority);
    final selectedDueDate = useState<DateTime?>(todo.dueDate);
    final selectedColorValue = useState<String?>(todo.colorValue);
    final titleError = useState<String?>(null);

    Future<void> saveTodo() async {
      if (editController.text.trim().isEmpty) {
        titleError.value = 'Title is required';
        return;
      }

      await ref
          .read(todoUsecaseProvider.notifier)
          .editTodo(
            todo.id,
            title: editController.text,
            priority: selectedPriority.value,
            dueDate: selectedDueDate.value,
            colorValue: selectedColorValue.value,
          );

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: const Text('Edit todo'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: math.min(MediaQuery.of(context).size.width, 420),
          child: TodoEditorFields(
            controller: editController,
            priority: selectedPriority.value,
            dueDate: selectedDueDate.value,
            colorValue: selectedColorValue.value,
            errorText: titleError.value,
            hintText: 'Update task title',
            autofocus: true,
            onTitleChanged: (_) {
              if (titleError.value != null) {
                titleError.value = null;
              }
            },
            onPriorityChanged: (priority) => selectedPriority.value = priority,
            onDueDateChanged: (dueDate) => selectedDueDate.value = dueDate,
            onColorChanged: (colorValue) =>
                selectedColorValue.value = colorValue,
            onSubmitted: saveTodo,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: saveTodo, child: const Text('Save')),
      ],
    );
  }
}
