import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: cs.onSurfaceVariant,
        ),
        filled: true,
        fillColor: cs.surfaceContainerLowest,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 20, color: cs.onSurfaceVariant),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 48,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: cs.primary.withValues(alpha: 0.45),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
