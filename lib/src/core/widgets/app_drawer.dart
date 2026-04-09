import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/settings/app_preferences.dart';
import 'package:todos_riverpod/src/core/settings/app_preferences_state.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final preferences = ref.watch(appPreferencesProvider);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            const _ProfileCard(),
            const SizedBox(height: 20),
            _SectionCard(
              title: 'Theme',
              subtitle: 'Choose how the app should look.',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ThemeMode.values
                    .map(
                      (mode) => ChoiceChip(
                        label: Text(_themeLabel(mode)),
                        selected: preferences.theme == mode,
                        onSelected: (_) {
                          ref
                              .read(appPreferencesProvider.notifier)
                              .updateThemeMode(mode);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Language',
              subtitle: 'Keep your workspace comfortable to read.',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppLanguage.values
                    .map(
                      (language) => ChoiceChip(
                        label: Text(language.label),
                        selected: preferences.appLanguage == language,
                        onSelected: (_) {
                          ref
                              .read(appPreferencesProvider.notifier)
                              .updateLanguage(language);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'App info',
              subtitle: 'A quick overview of this workspace.',
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.info_outline,
                    title: 'About this app',
                    subtitle:
                        'Built with Flutter, Riverpod, GoRouter, and Hive.',
                    onTap: () => _showAboutSheet(context),
                  ),
                  Divider(color: cs.outlineVariant, height: 16),
                  const _StaticInfoRow(label: 'Version', value: '1.0.0+1'),
                  const SizedBox(height: 10),
                  _StaticInfoRow(
                    label: 'Theme',
                    value: _themeLabel(preferences.theme),
                  ),
                  const SizedBox(height: 10),
                  _StaticInfoRow(
                    label: 'Language',
                    value: preferences.appLanguage.label,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };
  }

  static Future<void> _showAboutSheet(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: cs.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Todos Riverpod',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A minimal workspace for small productivity features, starting with Todo and ready for future tools.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                const _StaticInfoRow(label: 'Version', value: '1.0.0+1'),
                const SizedBox(height: 10),
                const _StaticInfoRow(
                  label: 'Stack',
                  value: 'Flutter + Riverpod',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: cs.primary.withValues(alpha: 0.12),
            foregroundColor: cs.primary,
            child: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Workspace',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Focus on a calm workflow and keep things organized.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 12,
      leading: Icon(icon, color: cs.onSurfaceVariant),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
      onTap: onTap,
    );
  }
}

class _StaticInfoRow extends StatelessWidget {
  const _StaticInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
