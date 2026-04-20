import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todos_riverpod/src/core/widgets/app_drawer.dart';
import 'package:todos_riverpod/src/router/app_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final availableFeatures = <_FeatureItem>[
      const _FeatureItem(
        title: 'Todos',
        subtitle: 'Track tasks with a calm, focused workflow.',
        icon: Icons.check_circle_outline,
        routeName: SGRoute.todo,
      ),
    ];

    final upcomingFeatures = <_FeatureItem>[
      const _FeatureItem(
        title: 'More features soon',
        subtitle: 'This space is ready for new tools as the app grows.',
        icon: Icons.grid_view_rounded,
        isEnabled: false,
      ),
    ];

    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Workspace')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _LandingHero(),
          const SizedBox(height: 24),
          _FeatureSection(title: 'Available now', items: availableFeatures),
          const SizedBox(height: 24),
          _FeatureSection(title: 'Coming next', items: upcomingFeatures),
        ],
      ),
    );
  }
}

class _LandingHero extends StatelessWidget {
  const _LandingHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'One place for your features',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start with Todo today, and keep this screen ready for the next tools you add later.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({required this.title, required this.items});

  final String title;
  final List<_FeatureItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FeatureTile(item: item),
          ),
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item});

  final _FeatureItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: item.isEnabled
          ? cs.surfaceContainerLowest
          : cs.surfaceContainerLowest.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: item.isEnabled && item.routeName != null
            ? () => context.pushNamed(item.routeName!.name)
            : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.isEnabled
                      ? cs.primary.withValues(alpha: 0.10)
                      : cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item.icon,
                  color: item.isEnabled ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                item.isEnabled ? Icons.arrow_forward_rounded : Icons.schedule,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.routeName,
    this.isEnabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final SGRoute? routeName;
  final bool isEnabled;
}
