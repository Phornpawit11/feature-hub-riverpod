import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/date_tag_form.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/date_tag_selector.dart';

class AddDateTagSheet extends HookWidget {
  const AddDateTagSheet({
    super.key,
    required this.tags,
    required this.onSelectTag,
    required this.onCreateTag,
    required this.onUpdateTag,
    required this.onDeleteTag,
  });

  final List<DateTag> tags;
  final ValueChanged<DateTag> onSelectTag;
  final Future<void> Function(String name, String colorValue) onCreateTag;
  final Future<void> Function(DateTag tag) onUpdateTag;
  final Future<void> Function(DateTag tag) onDeleteTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localTags = useState<List<DateTag>>(List.of(tags));

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
                existingTags: localTags.value,
                initialTag: tag,
                onSubmit: (name, colorValue) async {
                  final updatedTag = tag.copyWith(
                    name: name,
                    colorValue: colorValue,
                  );
                  await onUpdateTag(updatedTag);
                  localTags.value = [
                    for (final existingTag in localTags.value)
                      if (existingTag.id == updatedTag.id)
                        updatedTag
                      else
                        existingTag,
                  ];

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
                  localTags.value = [
                    for (final existingTag in localTags.value)
                      if (existingTag.id != tag.id) existingTag,
                  ];

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
                'Pick an existing tag or create a new one for this date.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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
                tags: localTags.value,
                onTagSelected: onSelectTag,
                onTagEdit: showEditTagSheet,
              ),
              const SizedBox(height: 24),
              DateTagForm(
                title: 'Create new tag',
                submitLabel: 'Save tag and apply',
                description:
                    'Create a reusable tag, then apply it to the selected date right away.',
                existingTags: localTags.value,
                onSubmit: onCreateTag,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
