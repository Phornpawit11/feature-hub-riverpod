import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/settings/app_preferences.dart';
import 'package:todos_riverpod/src/core/settings/app_preferences_state.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_notifier.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final preferences = ref.watch(appPreferencesProvider);
    final authState = ref.watch(authNotifierProvider);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            _ProfileCard(authState: authState),

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
            if (authState.status == AuthStatus.authenticated) ...[
              const SizedBox(height: 12),
              _SectionCard(
                child: _InfoTile(
                  icon: Icons.logout_rounded,
                  iconColor: cs.error,
                  title: 'Logout',
                  titleColor: cs.error,
                  subtitle: 'Return to the login screen on this device.',
                  subtitleColor: cs.onSurfaceVariant,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: cs.error.withValues(alpha: 0.8),
                  ),
                  onTap: () async {
                    final shouldLogout = await _showLogoutSheet(context);
                    if (shouldLogout != true) {
                      return;
                    }

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }

                    await ref.read(authNotifierProvider.notifier).signOut();
                  },
                ),
              ),
            ],
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

  static Future<bool?> _showLogoutSheet(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      backgroundColor: cs.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log out?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'ll return to the login screen on this device.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.error,
                      foregroundColor: cs.onError,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    child: const Text('Log out'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(false),
                    child: const Text('Cancel'),
                  ),
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
  const _ProfileCard({required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final user = authState.user;
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          _ProfileAvatar(user: isAuthenticated ? user : null),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAuthenticated && user != null
                      ? user.displayName
                      : 'Your Workspace',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAuthenticated && user != null
                      ? user.email
                      : authState.status == AuthStatus.restoring
                      ? 'Checking your session...'
                      : 'Sign in to personalize your workspace.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                if (isAuthenticated && user != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _providerLabel(user.provider),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _providerLabel(String provider) {
    return switch (provider) {
      'password' => 'Email login',
      'google' => 'Google',
      _ =>
        provider.isEmpty
            ? 'Account'
            : '${provider[0].toUpperCase()}${provider.substring(1)}',
    };
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final avatarUrl = user?.avatarUrl;

    final Widget avatarChild;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      avatarChild = ClipOval(
        child: Image.network(
          avatarUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _AvatarFallback(colorScheme: cs),
        ),
      );
    } else {
      avatarChild = _AvatarFallback(colorScheme: cs);
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: cs.primary.withValues(alpha: 0.12),
      foregroundColor: cs.primary,
      child: avatarChild,
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.person_outline, color: colorScheme.primary);
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({this.title, this.subtitle, required this.child});

  final String? title;
  final String? subtitle;
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
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title ?? "",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          if (title != null) const SizedBox(height: 4),
          if (title != null)
            Text(
              subtitle ?? "",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          if (title != null) const SizedBox(height: 14),
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
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 12,
      leading: Icon(icon, color: iconColor ?? cs.onSurfaceVariant),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: subtitleColor ?? cs.onSurfaceVariant,
        ),
      ),
      trailing:
          trailing ?? Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
