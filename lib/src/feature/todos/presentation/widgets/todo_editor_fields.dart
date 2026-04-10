import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/core/widgets/app_text_field.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';

class TodoEditorFields extends StatelessWidget {
  const TodoEditorFields({
    super.key,
    required this.controller,
    required this.priority,
    required this.dueDate,
    required this.colorValue,
    required this.onPriorityChanged,
    required this.onDueDateChanged,
    required this.onColorChanged,
    required this.onSubmitted,
    this.hintText = 'Task name',
    this.autofocus = false,
    this.errorText,
    this.onTitleChanged,
  });

  final TextEditingController controller;
  final TodoPriority priority;
  final DateTime? dueDate;
  final String? colorValue;
  final ValueChanged<TodoPriority> onPriorityChanged;
  final ValueChanged<DateTime?> onDueDateChanged;
  final ValueChanged<String?> onColorChanged;
  final Future<void> Function() onSubmitted;
  final String hintText;
  final bool autofocus;
  final String? errorText;
  final ValueChanged<String>? onTitleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: controller,
          hintText: hintText,
          prefixIcon: Icons.edit_outlined,
          autofocus: autofocus,
          errorText: errorText,
          onChanged: onTitleChanged,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmitted(),
        ),
        const SizedBox(height: 16),
        _PrioritySelector(selected: priority, onSelected: onPriorityChanged),
        const SizedBox(height: 16),
        _DueDateField(value: dueDate, onChanged: onDueDateChanged),
        const SizedBox(height: 16),
        _ColorSelector(
          selectedColorValue: colorValue,
          onSelected: onColorChanged,
        ),
      ],
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({required this.selected, required this.onSelected});

  final TodoPriority selected;
  final ValueChanged<TodoPriority> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<TodoPriority>(
          segments: TodoPriority.values
              .map(
                (priority) => ButtonSegment<TodoPriority>(
                  value: priority,
                  icon: Icon(
                    Icons.flag_rounded,
                    color: priorityColor(priority),
                  ),
                  label: Text(priority.label),
                ),
              )
              .toList(),
          style: ButtonStyle(
            side: WidgetStatePropertyAll(
              BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
          ),
          selected: <TodoPriority>{selected},
          onSelectionChanged: (selection) => onSelected(selection.first),
        ),
      ],
    );
  }
}

class _DueDateField extends StatelessWidget {
  const _DueDateField({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Future<void> pickDueDate() async {
      final now = DateTime.now();
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: value ?? now,
        firstDate: DateTime(now.year - 3),
        lastDate: DateTime(now.year + 5, 12, 31),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              datePickerTheme: DatePickerThemeData(
                headerHeadlineStyle: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        onChanged(dateOnly(pickedDate));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Due date', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              style: ButtonStyle(
                side: WidgetStatePropertyAll(
                  BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
                ),
              ),
              onPressed: pickDueDate,
              icon: const Icon(Icons.event_rounded),
              label: Text(
                value == null ? 'Pick a date' : formatTodoDate(value!),
              ),
            ),
            if (value != null)
              TextButton.icon(
                onPressed: () => onChanged(null),
                icon: Icon(Icons.close_rounded, color: cs.error),
                label: Text('Clear', style: TextStyle(color: cs.error)),
              ),
          ],
        ),
      ],
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({
    required this.selectedColorValue,
    required this.onSelected,
  });

  final String? selectedColorValue;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: todoColors.map((colorValue) {
            final isSelected = colorValue == selectedColorValue;
            final color = colorValue == null
                ? cs.surfaceContainerHigh
                : parseTodoColor(colorValue) ?? cs.surfaceContainerHigh;

            return InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onSelected(colorValue),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? cs.onSurface.withValues(alpha: 0.3)
                        : cs.outlineVariant,
                    width: isSelected ? 3 : 1.2,
                  ),
                ),
                child: colorValue == null
                    ? Icon(
                        Icons.block_rounded,
                        color: cs.onSurfaceVariant,
                        size: 18,
                      )
                    : isSelected
                    ? Icon(
                        Icons.check_rounded,
                        color: Colors.white.withValues(alpha: 0.92),
                        size: 18,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
