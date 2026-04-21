import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_usecase.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/date_tag_form.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/date_tag_selector.dart';

class AddDateTagSheet extends HookConsumerWidget {
  const AddDateTagSheet({
    super.key,
    required this.tags,
    required this.selectedDateListenable,
    required this.initialAssignedTag,
    required this.onSelectTag,
    required this.onCreateTag,
    required this.onUpdateTag,
    required this.onDeleteTag,
  });

  final List<DateTag> tags;
  final ValueListenable<DateTime> selectedDateListenable;
  final DateTag? initialAssignedTag;
  final Future<void> Function(DateTag tag) onSelectTag;
  final Future<void> Function(String name, String colorValue) onCreateTag;
  final Future<void> Function(DateTag tag) onUpdateTag;
  final Future<void> Function(DateTag tag) onDeleteTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = useValueListenable(selectedDateListenable);
    final isApplying = useState(false);
    final isCreateExpanded = useState(false);
    final tagState = ref.watch(dateTagUsecaseProvider).asData?.value;
    final displayTags = tagState?.tags ?? tags;
    final currentTaggedDate = tagState?.taggedDates
        .where(
          (taggedDate) => dateOnly(taggedDate.date) == dateOnly(selectedDate),
        )
        .firstOrNull;
    final assignedTag = currentTaggedDate == null
        ? initialAssignedTag
        : displayTags
              .where((tag) => tag.id == currentTaggedDate.tagId)
              .firstOrNull;

    Future<void> showEditTagSheet(DateTag tag) async {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (editContext) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20 + MediaQuery.viewInsetsOf(editContext).bottom,
              ),
              child: DateTagForm(
                title: 'Edit tag',
                submitLabel: 'Save changes',
                description:
                    'Update the tag name or color. Changes will apply everywhere this tag is used.',
                existingTags: displayTags,
                initialTag: tag,
                onSubmit: (name, colorValue) async {
                  final updatedTag = tag.copyWith(
                    name: name,
                    colorValue: colorValue,
                  );
                  await onUpdateTag(updatedTag);

                  if (editContext.mounted) {
                    Navigator.of(editContext).pop();
                  }
                },
                onDelete: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: editContext,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text('Delete tag?'),
                        content: Text(
                          'Delete "${tag.name}" and remove it from every assigned day?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldDelete != true) return;

                  await onDeleteTag(tag);

                  if (editContext.mounted) {
                    Navigator.of(editContext).pop();
                  }
                },
              ),
            ),
          );
        },
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Assign a tag',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pick an existing tag or create a new one for ${formatTodoDate(selectedDate)}.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _SelectedDateCard(
                selectedDate: selectedDate,
                assignedTag: assignedTag,
              ),
              const SizedBox(height: 20),
              Text(
                'Existing tags',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              DateTagSelector(
                tags: displayTags,
                enabled: !isApplying.value,
                onTagSelected: (tag) async {
                  isApplying.value = true;
                  await onSelectTag(tag);
                  if (context.mounted) {
                    isApplying.value = false;
                  }
                },
                onTagEdit: showEditTagSheet,
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isCreateExpanded.value
                    ? Container(
                        key: const ValueKey('expanded-create-tag'),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Create new tag',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Collapse create tag',
                                  onPressed: isApplying.value
                                      ? null
                                      : () => isCreateExpanded.value = false,
                                  icon: const Icon(Icons.close_rounded),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DateTagForm(
                              title: 'Tag details',
                              submitLabel: 'Save',
                              description:
                                  'Save a reusable tag first, then pick it from the row above to apply it to this date.',
                              existingTags: displayTags,
                              resetAfterSubmit: true,
                              onSubmit: (name, colorValue) async {
                                isApplying.value = true;
                                await onCreateTag(name, colorValue);
                                if (context.mounted) {
                                  isApplying.value = false;
                                  isCreateExpanded.value = false;
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        key: const ValueKey('collapsed-create-tag'),
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => isCreateExpanded.value = true,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Create new tag'),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedDateCard extends StatelessWidget {
  const _SelectedDateCard({
    required this.selectedDate,
    required this.assignedTag,
  });

  final DateTime selectedDate;
  final DateTag? assignedTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = parseTodoColor(assignedTag?.colorValue) ?? cs.primary;
    final useDarkForeground = cardColor.computeLuminance() > 0.5;
    final contentColor = cardColor.computeLuminance() > 0.5
        ? Colors.black.withValues(alpha: 0.78)
        : Colors.white.withValues(alpha: 0.94);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected date',
            style: theme.textTheme.labelMedium?.copyWith(
              color: contentColor.withValues(alpha: 0.82),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatTodoDate(selectedDate),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            assignedTag == null ? 'No tag assigned yet' : 'Current tag',
            style: theme.textTheme.labelMedium?.copyWith(
              color: contentColor.withValues(alpha: 0.82),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (assignedTag != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: useDarkForeground ? 0.28 : 0.14,
                ),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: contentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    assignedTag!.name,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: contentColor,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Create or pick a tag below to assign it later.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: contentColor.withValues(alpha: 0.82),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
