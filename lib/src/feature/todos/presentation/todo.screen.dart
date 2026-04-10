import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/core/widgets/app_drawer.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_state.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_usecase.dart';
import 'package:todos_riverpod/src/feature/todos/domain/todo.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/add_date_tag_sheet.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/edit_todo_dialog.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_calendar_section.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_composer_card.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_list_section.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/todo.usecase.dart';

enum _TodoViewMode { calendar, list }

class TodoScreen extends HookConsumerWidget {
  const TodoScreen({super.key});

  static const double _screenSwipeVelocityThreshold = 280;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final todoListAsync = ref.watch(todoUsecaseProvider);
    final dateTagAsync = ref.watch(dateTagUsecaseProvider);
    final textEditingController = useTextEditingController();
    final selectedPriority = useState(TodoPriority.medium);
    final selectedDueDate = useState<DateTime?>(null);
    final selectedColorValue = useState<String?>(null);
    final isComposerExpanded = useState(false);
    final viewMode = useState(_TodoViewMode.calendar);
    final now = DateTime.now();
    final focusedMonth = useState<DateTime>(DateTime(now.year, now.month));
    final selectedCalendarDate = useState<DateTime>(dateOnly(now));

    void resetComposer() {
      textEditingController.clear();
      selectedPriority.value = TodoPriority.medium;
      selectedDueDate.value = null;
      selectedColorValue.value = null;
    }

    Future<void> submitTodo() async {
      final title = textEditingController.text.trim();
      if (title.isEmpty) return;

      await ref
          .read(todoUsecaseProvider.notifier)
          .addTodo(
            title: title,
            priority: selectedPriority.value,
            dueDate: selectedDueDate.value,
            colorValue: selectedColorValue.value,
          );

      resetComposer();
      isComposerExpanded.value = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    Future<void> showEditTodoDialog(Todo todo) async {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => EditTodoDialog(todo: todo),
      );
    }

    void changeFocusedMonth(DateTime month) {
      final normalizedMonth = DateTime(month.year, month.month);
      focusedMonth.value = normalizedMonth;
      selectedCalendarDate.value = normalizedMonth;
    }

    void switchToListMode() {
      viewMode.value = _TodoViewMode.list;
    }

    void switchToCalendarMode() {
      viewMode.value = _TodoViewMode.calendar;
    }

    Future<void> deleteTodo(String todoId) async {
      await ref.read(todoUsecaseProvider.notifier).deleteTodo(todoId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    Future<void> showDateTagSheet(DateTagState tagState) async {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (sheetContext) {
          return AddDateTagSheet(
            tags: tagState.tags,
            onSelectTag: (tag) async {
              await ref
                  .read(dateTagUsecaseProvider.notifier)
                  .assignTagToDate(selectedCalendarDate.value, tag.id);

              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop();
              }
            },
            onCreateTag: (name, colorValue) async {
              await ref
                  .read(dateTagUsecaseProvider.notifier)
                  .createTagAndAssignToDate(
                    date: selectedCalendarDate.value,
                    name: name,
                    colorValue: colorValue,
                  );

              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop();
              }
            },
            onUpdateTag: (tag) {
              return ref.read(dateTagUsecaseProvider.notifier).updateTag(tag);
            },
            onDeleteTag: (tag) {
              return ref
                  .read(dateTagUsecaseProvider.notifier)
                  .deleteTag(tag.id);
            },
          );
        },
      );
    }

    Future<void> removeDateTag() async {
      await ref
          .read(dateTagUsecaseProvider.notifier)
          .removeTagFromDate(selectedCalendarDate.value);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      endDrawer: const AppDrawer(),

      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              final velocity = (details.primaryVelocity ?? 0).abs();
              if (velocity < _screenSwipeVelocityThreshold) {
                return;
              }

              if (viewMode.value == _TodoViewMode.calendar) {
                switchToListMode();
              } else {
                switchToCalendarMode();
              }
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 124),
              children: [
                TodoComposerCard(
                  title: 'New task',
                  isExpanded: isComposerExpanded.value,
                  controller: textEditingController,
                  priority: selectedPriority.value,
                  dueDate: selectedDueDate.value,
                  colorValue: selectedColorValue.value,
                  buttonLabel: 'Add task',
                  onExpand: () => isComposerExpanded.value = true,
                  onCollapse: () {
                    resetComposer();
                    isComposerExpanded.value = false;
                  },
                  onPriorityChanged: (priority) =>
                      selectedPriority.value = priority,
                  onDueDateChanged: (dueDate) =>
                      selectedDueDate.value = dueDate,
                  onColorChanged: (colorValue) =>
                      selectedColorValue.value = colorValue,
                  onSubmit: submitTodo,
                ),
                const SizedBox(height: 20),
                todoListAsync.when(
                  data: (todos) => dateTagAsync.when(
                    data: (tagState) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: viewMode.value == _TodoViewMode.list
                            ? TodoListSection(
                                key: const ValueKey('list-view'),
                                todos: todos,
                                onEdit: showEditTodoDialog,
                                onToggle: (todoId) {
                                  ref
                                      .read(todoUsecaseProvider.notifier)
                                      .toggleTodo(todoId);
                                },
                                onDelete: deleteTodo,
                              )
                            : TodoCalendarSection(
                                key: const ValueKey('calendar-view'),
                                todos: todos,
                                focusedMonth: focusedMonth.value,
                                selectedDate: selectedCalendarDate.value,
                                dateTagsByDay: tagState.assignedTagByDate,
                                onMonthChanged: changeFocusedMonth,
                                onDateSelected: (date) =>
                                    selectedCalendarDate.value = date,
                                onAddTag: () => showDateTagSheet(tagState),
                                onChangeTag: () => showDateTagSheet(tagState),
                                onRemoveTag: removeDateTag,
                                onEdit: showEditTodoDialog,
                                onToggle: (todoId) {
                                  ref
                                      .read(todoUsecaseProvider.notifier)
                                      .toggleTodo(todoId);
                                },
                                onDelete: deleteTodo,
                              ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('Something went wrong')),
                    ),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('Something went wrong')),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              offset: isKeyboardVisible ? const Offset(0, 1.2) : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 160),
                opacity: isKeyboardVisible ? 0 : 1,
                child: IgnorePointer(
                  ignoring: isKeyboardVisible,
                  child: SafeArea(
                    top: false,
                    child: _FloatingViewModeSwitcher(
                      selectedViewMode: viewMode.value,
                      onChanged: (mode) => viewMode.value = mode,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingViewModeSwitcher extends StatelessWidget {
  const _FloatingViewModeSwitcher({
    required this.selectedViewMode,
    required this.onChanged,
  });

  final _TodoViewMode selectedViewMode;
  final ValueChanged<_TodoViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: cs.surface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.72)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SegmentedButton<_TodoViewMode>(
          showSelectedIcon: false,
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,

            visualDensity: VisualDensity.compact,
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return cs.primary.withValues(alpha: 0.14);
              }
              return Colors.transparent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return cs.primary;
              }
              return cs.onSurfaceVariant;
            }),
            textStyle: WidgetStatePropertyAll(
              Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            side: const WidgetStatePropertyAll(BorderSide.none),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          segments: const [
            ButtonSegment<_TodoViewMode>(
              value: _TodoViewMode.calendar,
              icon: Icon(Icons.calendar_month_rounded),
              label: Text('Calendar'),
            ),
            ButtonSegment<_TodoViewMode>(
              value: _TodoViewMode.list,
              icon: Icon(Icons.view_list_rounded),
              label: Text('List'),
            ),
          ],
          selected: <_TodoViewMode>{selectedViewMode},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ),
    );
  }
}
