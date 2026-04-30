import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todos_riverpod/src/core/widgets/app_drawer.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_state.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/calendar_background_usecase.dart';
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
  const TodoScreen({
    super.key,
    this.initialFocusedMonth,
    this.initialSelectedDate,
  });

  static const double _screenSwipeVelocityThreshold = 280;
  final DateTime? initialFocusedMonth;
  final DateTime? initialSelectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final todoListAsync = ref.watch(todoUsecaseProvider);
    final dateTagAsync = ref.watch(dateTagUsecaseProvider);
    final calendarBackgroundAsync = ref.watch(calendarBackgroundUsecaseProvider);
    final isCalendarBackgroundPickerSupported = ref.watch(
      isMobileCalendarBackgroundPickerSupportedProvider,
    );
    final textEditingController = useTextEditingController();
    final selectedPriority = useState(TodoPriority.medium);
    final selectedDueDate = useState<DateTime?>(null);
    final selectedColorValue = useState<String?>(null);
    final isComposerExpanded = useState(false);
    final isSubmittingTodo = useState(false);
    final viewMode = useState(_TodoViewMode.calendar);
    final now = DateTime.now();
    final initialSelectedCalendarDate = dateOnly(initialSelectedDate ?? now);
    final initialCalendarMonth = DateTime(
      (initialFocusedMonth ?? initialSelectedCalendarDate).year,
      (initialFocusedMonth ?? initialSelectedCalendarDate).month,
    );
    final focusedMonth = useState<DateTime>(initialCalendarMonth);
    final selectedCalendarDate = useState<DateTime>(initialSelectedCalendarDate);

    void resetComposer() {
      textEditingController.clear();
      selectedPriority.value = TodoPriority.medium;
      selectedDueDate.value = null;
      selectedColorValue.value = null;
    }

    Future<void> submitTodo() async {
      final title = textEditingController.text.trim();
      if (title.isEmpty || isSubmittingTodo.value) return;

      isSubmittingTodo.value = true;
      try {
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
      } finally {
        isSubmittingTodo.value = false;
      }
    }

    Future<void> showEditTodoDialog(Todo todo) async {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => EditTodoDialog(todo: todo),
      );
    }

    Future<void> pickCalendarBackgroundImage() async {
      if (!isCalendarBackgroundPickerSupported) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery background is available on mobile only.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
      );

      if (image == null) {
        return;
      }

      await ref
          .read(calendarBackgroundUsecaseProvider.notifier)
          .setCalendarBackground(image.path);
    }

    Future<void> clearCalendarBackgroundImage() async {
      await ref
          .read(calendarBackgroundUsecaseProvider.notifier)
          .clearCalendarBackground();
    }

    void changeFocusedMonth(DateTime month) {
      focusedMonth.value = DateTime(month.year, month.month);

      final current = selectedCalendarDate.value;

      // ถ้าอยู่เดือนเดิมแล้ว ไม่ต้องเปลี่ยน selected date
      if (current.year == month.year && current.month == month.month) return;

      // คง day เดิมไว้ถ้าทำได้ ถ้าไม่มีในเดือนนั้น (เช่น 31 ใน Feb) ใช้วันสุดท้าย
      final lastDayOfMonth = DateTime(month.year, month.month + 1, 0).day;
      final targetDay = current.day.clamp(1, lastDayOfMonth);
      selectedCalendarDate.value = DateTime(month.year, month.month, targetDay);
    }

    void switchToListMode() {
      viewMode.value = _TodoViewMode.list;
    }

    void switchToCalendarMode() {
      viewMode.value = _TodoViewMode.calendar;
    }

    void advanceSelectedCalendarDate() {
      final nextDate = dateOnly(
        selectedCalendarDate.value.add(const Duration(days: 1)),
      );
      selectedCalendarDate.value = nextDate;
      focusedMonth.value = DateTime(nextDate.year, nextDate.month);
    }

    DateTime? findNextTaggedDateInFocusedMonth({
      required DateTime currentDate,
      required DateTime month,
      required Map<DateTime, DateTag> assignedTagByDate,
    }) {
      final monthCandidates =
          assignedTagByDate.keys
              .map(dateOnly)
              .where(
                (date) =>
                    date.year == month.year &&
                    date.month == month.month &&
                    date != currentDate,
              )
              .toList()
            ..sort();

      for (final candidate in monthCandidates.reversed) {
        if (candidate.isBefore(currentDate)) {
          return candidate;
        }
      }

      for (final candidate in monthCandidates) {
        if (candidate.isAfter(currentDate)) {
          return candidate;
        }
      }

      return null;
    }

    Future<void> deleteTodo(String todoId) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete task?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

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
            selectedDateListenable: selectedCalendarDate,
            initialAssignedTag: tagState
                .assignedTagByDate[dateOnly(selectedCalendarDate.value)],
            onSelectTag: (tag) async {
              final currentDate = selectedCalendarDate.value;
              await ref
                  .read(dateTagUsecaseProvider.notifier)
                  .assignTagToDate(currentDate, tag.id);
              advanceSelectedCalendarDate();
            },
            onCreateTag: (name, colorValue) async {
              await ref
                  .read(dateTagUsecaseProvider.notifier)
                  .createTag(name: name, colorValue: colorValue);
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
      final currentDate = selectedCalendarDate.value;
      final currentMonth = focusedMonth.value;
      final tagState =
          ref.read(dateTagUsecaseProvider).asData?.value ??
          dateTagAsync.asData?.value;
      final nextFocusDate = tagState == null
          ? null
          : findNextTaggedDateInFocusedMonth(
              currentDate: currentDate,
              month: currentMonth,
              assignedTagByDate: tagState.assignedTagByDate,
            );

      await ref
          .read(dateTagUsecaseProvider.notifier)
          .removeTagFromDate(currentDate);

      if (nextFocusDate != null) {
        selectedCalendarDate.value = nextFocusDate;
      }
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
                  onSubmit: isSubmittingTodo.value ? null : submitTodo,
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
                                backgroundImagePath:
                                    calendarBackgroundAsync.asData?.value,
                                onPickBackgroundImage:
                                    pickCalendarBackgroundImage,
                                onClearBackgroundImage:
                                    clearCalendarBackgroundImage,
                                isBackgroundImagePickerSupported:
                                    isCalendarBackgroundPickerSupported,
                              ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Something went wrong'),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  ref.invalidate(dateTagUsecaseProvider),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Something went wrong'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                ref.invalidate(todoUsecaseProvider),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
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
