import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todos_riverpod/src/core/widgets/app_text_field.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/date_tag_selector.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/todo_presentation_utils.dart';

class DateTagForm extends HookWidget {
  const DateTagForm({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.existingTags,
    required this.onSubmit,
    this.initialTag,
    this.onDelete,
    this.description,
  });

  final String title;
  final String submitLabel;
  final List<DateTag> existingTags;
  final Future<void> Function(String name, String colorValue) onSubmit;
  final Future<void> Function()? onDelete;
  final DateTag? initialTag;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameController = useTextEditingController(
      text: initialTag?.name ?? '',
    );
    final selectedColorValue = useState<String>(
      initialTag?.colorValue ?? todoColors.whereType<String>().first,
    );
    final nameError = useState<String?>(null);
    final isSubmitting = useState(false);

    Future<void> submit() async {
      final trimmedName = nameController.text.trim();
      if (trimmedName.isEmpty) {
        nameError.value = 'Tag name is required';
        return;
      }

      final duplicateExists = existingTags.any(
        (tag) =>
            tag.id != initialTag?.id &&
            tag.name.trim().toLowerCase() == trimmedName.toLowerCase(),
      );

      if (duplicateExists) {
        nameError.value = 'Tag name already exists';
        return;
      }

      isSubmitting.value = true;
      await onSubmit(trimmedName, selectedColorValue.value);
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 6),
          Text(
            description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 12),
        AppTextField(
          controller: nameController,
          hintText: 'Tag name',
          prefixIcon: Icons.label_outline_rounded,
          errorText: nameError.value,
          onChanged: (_) => nameError.value = null,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => submit(),
        ),
        const SizedBox(height: 16),
        Text(
          'Color',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        DateTagColorSelector(
          selectedColorValue: selectedColorValue.value,
          onSelected: (colorValue) => selectedColorValue.value = colorValue,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            if (onDelete != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isSubmitting.value ? null : onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete'),
                ),
              ),
            if (onDelete != null) const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: isSubmitting.value ? null : submit,
                icon: Icon(
                  initialTag == null
                      ? Icons.add_rounded
                      : Icons.check_circle_outline_rounded,
                ),
                label: Text(submitLabel),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
