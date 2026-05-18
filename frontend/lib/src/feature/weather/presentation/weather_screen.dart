import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';
import 'package:todos_riverpod/src/feature/weather/presentation/weather_visual_tone.dart';
import 'package:todos_riverpod/src/feature/weather/usecase/weather_state.dart';
import 'package:todos_riverpod/src/feature/weather/usecase/weather_usecase.dart';

class WeatherScreen extends HookConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final weatherState = ref.watch(weatherUsecaseProvider);
    final notifier = ref.read(weatherUsecaseProvider.notifier);
    final scrollController = useScrollController();
    final revealController = useAnimationController(
      duration: const Duration(milliseconds: 900),
    );
    final pulseController = useAnimationController(
      duration: const Duration(milliseconds: 1400),
    );
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final scrollOffset = useState(0.0);
    final debugToneOverride = useState<WeatherToneKind?>(null);

    useEffect(() {
      void listener() {
        scrollOffset.value = scrollController.hasClients
            ? scrollController.offset
            : 0;
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    useEffect(() {
      if (disableAnimations) {
        revealController.value = 1;
      } else if (weatherState.hasData || weatherState.isLoading) {
        revealController.forward(from: 0);
      }
      return null;
    }, [weatherState.snapshot, weatherState.status, disableAnimations]);

    useEffect(() {
      if (disableAnimations) {
        pulseController.value = 1;
        return null;
      }

      if (weatherState.isLoading) {
        pulseController.repeat(reverse: true);
      } else {
        pulseController.stop();
        pulseController.value = 1;
      }
      return null;
    }, [weatherState.isLoading, disableAnimations]);

    final revealValue = disableAnimations
        ? 1.0
        : useAnimation(revealController);
    final pulseValue = disableAnimations ? 1.0 : useAnimation(pulseController);
    final animationValue = disableAnimations ? 1.0 : revealValue;
    final snapshot = weatherState.snapshot;
    final resolvedTone = snapshot == null
        ? loadingWeatherTone()
        : resolveWeatherTone(snapshot.current);
    final tone = debugToneOverride.value == null
        ? resolvedTone
        : toneForKind(debugToneOverride.value!);
    final infoMessage = weatherState.isUsingFallbackLocation
        ? 'Using Bangkok as a fallback while live location is unavailable.'
        : 'Live conditions based on your current location.';

    return Scaffold(
      backgroundColor: tone.scaffoldBackground,
      body: Stack(
        children: [
          _WeatherBackdrop(
            scrollOffset: scrollOffset.value,
            animate: !disableAnimations,
            tone: tone,
          ),
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: tone.buttonForeground,
              backgroundColor: tone.buttonBackground.withValues(alpha: 0.96),
              onRefresh: notifier.loadWeather,
              child: ListView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  _StaggerReveal(
                    progress: animationValue,
                    intervalStart: 0.0,
                    intervalEnd: 0.32,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skyline',
                                style: textTheme.titleMedium?.copyWith(
                                  color: tone.textSecondary,
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                snapshot == null
                                    ? 'Weather Tracker'
                                    : snapshot.locationName,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: tone.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _GlassIconButton(
                          icon: Icons.refresh_rounded,
                          tone: tone,
                          onPressed: weatherState.isBusy
                              ? null
                              : notifier.loadWeather,
                        ),
                        if (kDebugMode) ...[
                          const SizedBox(width: 12),
                          _DebugToneButton(
                            tone: tone,
                            selectedTone: debugToneOverride.value,
                            onSelected: (value) {
                              debugToneOverride.value = value;
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _StaggerReveal(
                    progress: animationValue,
                    intervalStart: 0.08,
                    intervalEnd: 0.48,
                    child: _CurrentWeatherPanel(
                      state: weatherState,
                      pulseValue: pulseValue,
                      infoMessage: infoMessage,
                      onRetry: notifier.loadWeather,
                      tone: tone,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _StaggerReveal(
                    progress: animationValue,
                    intervalStart: 0.22,
                    intervalEnd: 0.64,
                    child: Text(
                      'Hourly forecast',
                      style: textTheme.titleLarge?.copyWith(
                        color: tone.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _StaggerReveal(
                    progress: animationValue,
                    intervalStart: 0.26,
                    intervalEnd: 0.74,
                    child: _HourlyForecastSection(
                      state: weatherState,
                      pulseValue: pulseValue,
                      tone: tone,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _StaggerReveal(
                    progress: animationValue,
                    intervalStart: 0.34,
                    intervalEnd: 0.82,
                    child: Text(
                      'Daily outlook',
                      style: textTheme.titleLarge?.copyWith(
                        color: tone.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _StaggerReveal(
                    progress: animationValue,
                    intervalStart: 0.40,
                    intervalEnd: 1.0,
                    child: _DailyForecastSection(
                      state: weatherState,
                      pulseValue: pulseValue,
                      tone: tone,
                    ),
                  ),
                  if (snapshot != null &&
                      weatherState.errorMessage != null) ...[
                    const SizedBox(height: 18),
                    _GlassPanel(
                      tone: tone,
                      child: Text(
                        weatherState.errorMessage!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: tone.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugToneButton extends StatelessWidget {
  const _DebugToneButton({
    required this.tone,
    required this.selectedTone,
    required this.onSelected,
  });

  final WeatherVisualTone tone;
  final WeatherToneKind? selectedTone;
  final ValueChanged<WeatherToneKind?> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<WeatherToneKind?>(
      tooltip: 'Debug weather tone',
      initialValue: selectedTone,
      onSelected: onSelected,
      color: tone.scaffoldBackground.withValues(alpha: 0.96),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      itemBuilder: (context) => [
        CheckedPopupMenuItem<WeatherToneKind?>(
          checked: selectedTone == null,
          child: const Text('Auto'),
        ),
        ...WeatherToneKind.values
            .where((kind) => kind != WeatherToneKind.neutral)
            .map(
              (kind) => CheckedPopupMenuItem<WeatherToneKind?>(
                value: kind,
                checked: selectedTone == kind,
                child: Text(_debugToneLabel(kind)),
              ),
            ),
      ],
      child: _GlassPanel(
        tone: tone,
        borderRadius: 22,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bug_report_rounded,
              size: 18,
              color: tone.buttonForeground.withValues(alpha: 0.92),
            ),
            const SizedBox(width: 8),
            Text(
              selectedTone == null ? 'Auto' : _debugToneLabel(selectedTone!),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: tone.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _debugToneLabel(WeatherToneKind kind) {
  return switch (kind) {
    WeatherToneKind.neutral => 'Neutral',
    WeatherToneKind.clearDay => 'Clear Day',
    WeatherToneKind.clearNight => 'Clear Night',
    WeatherToneKind.cloudy => 'Cloudy',
    WeatherToneKind.rain => 'Rain',
    WeatherToneKind.thunderstorm => 'Storm',
    WeatherToneKind.snow => 'Snow',
    WeatherToneKind.mist => 'Mist',
  };
}

class _CurrentWeatherPanel extends StatelessWidget {
  const _CurrentWeatherPanel({
    required this.state,
    required this.pulseValue,
    required this.infoMessage,
    required this.onRetry,
    required this.tone,
  });

  final WeatherState state;
  final double pulseValue;
  final String infoMessage;
  final Future<void> Function() onRetry;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    final isCompactLayout =
        mediaQuery.size.width < 380 || mediaQuery.textScaler.scale(1) > 1.15;

    if (snapshot == null && state.status == WeatherStatus.error) {
      return _GlassPanel(
        tone: tone,
        padding: const EdgeInsets.all(22),
        borderRadius: 34,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather unavailable',
              style: textTheme.headlineSmall?.copyWith(
                color: tone.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              state.errorMessage ?? 'Unable to load weather right now.',
              style: textTheme.bodyMedium?.copyWith(color: tone.textSecondary),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: tone.buttonBackground,
                foregroundColor: tone.buttonForeground,
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (snapshot == null) {
      return _LoadingCurrentWeatherPanel(pulseValue: pulseValue, tone: tone);
    }

    final current = snapshot.current;
    final header = state.isUsingFallbackLocation
        ? '${snapshot.locationName} • Fallback'
        : snapshot.locationName;

    return _GlassPanel(
      tone: tone,
      padding: const EdgeInsets.all(22),
      borderRadius: 34,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: tone.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      infoMessage,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge?.copyWith(
                        color: tone.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _WeatherGlyph(iconCode: current.iconCode, size: 72, tone: tone),
            ],
          ),
          const SizedBox(height: 26),
          isCompactLayout
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${current.temperatureCelsius.round()}°',
                      style: textTheme.displaySmall?.copyWith(
                        color: tone.textPrimary,
                        fontWeight: FontWeight.w700,
                        height: 0.95,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CurrentWeatherDetails(current: current, tone: tone),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${current.temperatureCelsius.round()}°',
                      style: textTheme.displaySmall?.copyWith(
                        color: tone.textPrimary,
                        fontWeight: FontWeight.w700,
                        height: 0.95,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CurrentWeatherDetails(
                          current: current,
                          tone: tone,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricTile(
                child: _MiniWeatherMetric(
                  label: 'Sunset',
                  value: _formatTime(current.sunsetAt),
                  icon: Icons.wb_sunny_outlined,
                  tone: tone,
                ),
              ),
              _MetricTile(
                child: _MiniWeatherMetric(
                  label: 'Rain',
                  value: '${current.precipitationChance}%',
                  icon: Icons.water_drop_outlined,
                  tone: tone,
                ),
              ),
              _MetricTile(
                child: _MiniWeatherMetric(
                  label: 'Humidity',
                  value: '${current.humidityPercent}%',
                  icon: Icons.air_rounded,
                  tone: tone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HourlyForecastSection extends StatelessWidget {
  const _HourlyForecastSection({
    required this.state,
    required this.pulseValue,
    required this.tone,
  });

  final WeatherState state;
  final double pulseValue;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;

    if (snapshot == null) {
      return SizedBox(
        height: 158,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, _) =>
              _LoadingHourlyTile(pulseValue: pulseValue, tone: tone),
        ),
      );
    }

    return SizedBox(
      height: 158,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = snapshot.hourly[index];
          return _HourlyForecastTile(item: item, tone: tone);
        },
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemCount: snapshot.hourly.length,
      ),
    );
  }
}

class _DailyForecastSection extends StatelessWidget {
  const _DailyForecastSection({
    required this.state,
    required this.pulseValue,
    required this.tone,
  });

  final WeatherState state;
  final double pulseValue;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.snapshot;

    if (snapshot == null) {
      return Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _LoadingDailyTile(pulseValue: pulseValue, tone: tone),
          ),
        ),
      );
    }

    return Column(
      children: snapshot.daily
          .map(
            (forecast) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DailyForecastTile(forecast: forecast, tone: tone),
            ),
          )
          .toList(),
    );
  }
}

class _CurrentWeatherDetails extends StatelessWidget {
  const _CurrentWeatherDetails({required this.current, required this.tone});

  final CurrentWeather current;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          current.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            color: tone.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Feels like ${current.feelsLikeCelsius.round()}°  •  Wind ${current.windSpeedKph.round()} km/h',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(color: tone.textTertiary),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 64) / 3;
    return SizedBox(width: width.clamp(96.0, 160.0), child: child);
  }
}

class _WeatherBackdrop extends StatelessWidget {
  const _WeatherBackdrop({
    required this.scrollOffset,
    required this.animate,
    required this.tone,
  });

  final double scrollOffset;
  final bool animate;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final shift = animate ? scrollOffset * 0.08 : 0.0;

    return Container(
      key: const Key('weather-backdrop'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: tone.backdropColors,
          stops: tone.backdropStops,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80 - shift,
            left: -20,
            child: _GlowOrb(size: 220, colors: tone.orbTopLeft),
          ),
          Positioned(
            top: 160 + shift,
            right: -30,
            child: _GlowOrb(size: 260, colors: tone.orbTopRight),
          ),
          Positioned(
            bottom: 120 - shift,
            left: -40,
            child: _GlowOrb(size: 240, colors: tone.orbBottomLeft),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.child,
    required this.tone,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 28,
  });

  final Widget child;
  final WeatherVisualTone tone;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [tone.panelGradientStart, tone.panelGradientEnd],
            ),
            border: Border.all(color: tone.panelBorder),
            boxShadow: [
              BoxShadow(
                color: tone.panelShadow,
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: tone.surfaceTint,
                blurRadius: 2,
                offset: const Offset(-2, -2),
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onPressed,
    required this.tone,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      tone: tone,
      borderRadius: 22,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: 52,
        height: 52,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: tone.buttonForeground.withValues(alpha: 0.92),
          ),
        ),
      ),
    );
  }
}

class _MiniWeatherMetric extends StatelessWidget {
  const _MiniWeatherMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String value;
  final IconData icon;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: tone.metricFill,
        border: Border.all(color: tone.metricBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tone.textSecondary, size: 18),
          const SizedBox(height: 14),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: tone.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: tone.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _HourlyForecastTile extends StatelessWidget {
  const _HourlyForecastTile({required this.item, required this.tone});

  final HourlyForecastItem item;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 112,
      child: _GlassPanel(
        tone: tone,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatHourlyLabel(item.time),
              style: textTheme.bodyMedium?.copyWith(
                color: tone.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            _WeatherGlyph(iconCode: item.iconCode, size: 46, tone: tone),
            const SizedBox(height: 16),
            Text(
              '${item.temperatureCelsius.round()}°',
              style: textTheme.titleLarge?.copyWith(
                color: tone.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyForecastTile extends StatelessWidget {
  const _DailyForecastTile({required this.forecast, required this.tone});

  final DailyForecastItem forecast;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _GlassPanel(
      tone: tone,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          _WeatherGlyph(iconCode: forecast.iconCode, size: 52, tone: tone),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatWeekday(forecast.date),
                  style: textTheme.titleMedium?.copyWith(
                    color: tone.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  forecast.condition,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: tone.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${forecast.lowCelsius.round()}°',
            style: textTheme.bodyLarge?.copyWith(
              color: tone.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '${forecast.highCelsius.round()}°',
            style: textTheme.titleMedium?.copyWith(
              color: tone.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCurrentWeatherPanel extends StatelessWidget {
  const _LoadingCurrentWeatherPanel({
    required this.pulseValue,
    required this.tone,
  });

  final double pulseValue;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      tone: tone,
      padding: const EdgeInsets.all(22),
      borderRadius: 34,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GlassPlaceholder(
                      width: 180,
                      height: 18,
                      pulseValue: pulseValue,
                      tone: tone,
                    ),
                    const SizedBox(height: 10),
                    _GlassPlaceholder(
                      width: double.infinity,
                      height: 14,
                      pulseValue: pulseValue,
                      tone: tone,
                    ),
                  ],
                ),
              ),
              _GlassPlaceholder(
                width: 72,
                height: 72,
                borderRadius: 36,
                pulseValue: pulseValue,
                tone: tone,
              ),
            ],
          ),
          const SizedBox(height: 26),
          _GlassPlaceholder(
            width: 120,
            height: 54,
            pulseValue: pulseValue,
            tone: tone,
          ),
          const SizedBox(height: 24),
          const Row(children: [Expanded(child: SizedBox())]),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _GlassPlaceholder(
                  height: 96,
                  borderRadius: 22,
                  pulseValue: pulseValue,
                  tone: tone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GlassPlaceholder(
                  height: 96,
                  borderRadius: 22,
                  pulseValue: pulseValue,
                  tone: tone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GlassPlaceholder(
                  height: 96,
                  borderRadius: 22,
                  pulseValue: pulseValue,
                  tone: tone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingHourlyTile extends StatelessWidget {
  const _LoadingHourlyTile({required this.pulseValue, required this.tone});

  final double pulseValue;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: _GlassPanel(
        tone: tone,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GlassPlaceholder(
              width: 48,
              height: 14,
              pulseValue: pulseValue,
              tone: tone,
            ),
            const Spacer(),
            _GlassPlaceholder(
              width: 46,
              height: 46,
              pulseValue: pulseValue,
              tone: tone,
            ),
            const SizedBox(height: 16),
            _GlassPlaceholder(
              width: 42,
              height: 18,
              pulseValue: pulseValue,
              tone: tone,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDailyTile extends StatelessWidget {
  const _LoadingDailyTile({required this.pulseValue, required this.tone});

  final double pulseValue;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      tone: tone,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          _GlassPlaceholder(
            width: 52,
            height: 52,
            pulseValue: pulseValue,
            tone: tone,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GlassPlaceholder(
                  width: 96,
                  height: 16,
                  pulseValue: pulseValue,
                  tone: tone,
                ),
                const SizedBox(height: 8),
                _GlassPlaceholder(
                  width: 140,
                  height: 12,
                  pulseValue: pulseValue,
                  tone: tone,
                ),
              ],
            ),
          ),
          _GlassPlaceholder(
            width: 32,
            height: 14,
            pulseValue: pulseValue,
            tone: tone,
          ),
          const SizedBox(width: 14),
          _GlassPlaceholder(
            width: 32,
            height: 18,
            pulseValue: pulseValue,
            tone: tone,
          ),
        ],
      ),
    );
  }
}

class _GlassPlaceholder extends StatelessWidget {
  const _GlassPlaceholder({
    this.width,
    required this.height,
    required this.pulseValue,
    required this.tone,
    this.borderRadius = 18,
  });

  final double? width;
  final double height;
  final double pulseValue;
  final WeatherVisualTone tone;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final alpha = lerpDouble(0.14, 0.26, pulseValue) ?? 0.2;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Color.lerp(
          tone.metricFill.withValues(alpha: 0.55),
          tone.panelBorder.withValues(alpha: 0.36),
          pulseValue,
        )?.withValues(alpha: alpha + 0.12),
      ),
    );
  }
}

class _WeatherGlyph extends StatelessWidget {
  const _WeatherGlyph({
    required this.iconCode,
    required this.size,
    required this.tone,
  });

  final String iconCode;
  final double size;
  final WeatherVisualTone tone;

  @override
  Widget build(BuildContext context) {
    final icon = _WeatherUiTokens.iconFor(iconCode);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.36),
        gradient: LinearGradient(
          colors: [tone.iconGradientStart, tone.iconGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: tone.iconShadow,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, color: tone.iconForeground, size: size * 0.46),
    );
  }
}

class _StaggerReveal extends StatelessWidget {
  const _StaggerReveal({
    required this.progress,
    required this.intervalStart,
    required this.intervalEnd,
    required this.child,
  });

  final double progress;
  final double intervalStart;
  final double intervalEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clamped = ((progress - intervalStart) / (intervalEnd - intervalStart))
        .clamp(0.0, 1.0);
    final eased = Curves.easeOutCubic.transform(clamped);

    return Opacity(
      opacity: eased,
      child: Transform.translate(
        offset: Offset(0, (1 - eased) * 26),
        child: child,
      ),
    );
  }
}

class _WeatherUiTokens {
  static IconData iconFor(String iconCode) {
    if (iconCode.startsWith('01')) {
      return iconCode.endsWith('n')
          ? Icons.mode_night_rounded
          : Icons.wb_sunny_rounded;
    }
    if (iconCode.startsWith('02') || iconCode.startsWith('03')) {
      return Icons.cloud_rounded;
    }
    if (iconCode.startsWith('04')) {
      return Icons.cloud_circle_rounded;
    }
    if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      return Icons.grain_rounded;
    }
    if (iconCode.startsWith('11')) {
      return Icons.thunderstorm_rounded;
    }
    if (iconCode.startsWith('13')) {
      return Icons.ac_unit_rounded;
    }
    if (iconCode.startsWith('50')) {
      return Icons.blur_on_rounded;
    }

    return Icons.wb_twilight_rounded;
  }
}

String _formatTime(DateTime value) {
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute $suffix';
}

String _formatHourlyLabel(DateTime value) {
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '$hour $suffix';
}

String _formatWeekday(DateTime value) {
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return weekdays[(value.weekday - 1).clamp(0, 6)];
}
