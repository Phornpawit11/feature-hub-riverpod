import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';
import 'package:todos_riverpod/src/feature/weather/presentation/weather_screen.dart';
import 'package:todos_riverpod/src/feature/weather/presentation/weather_visual_tone.dart';
import 'package:todos_riverpod/src/feature/weather/usecase/weather_state.dart';
import 'package:todos_riverpod/src/feature/weather/usecase/weather_usecase.dart';

void main() {
  group('WeatherScreen', () {
    testWidgets('shows loading placeholders while weather is loading', (
      tester,
    ) async {
      final fakeNotifier = _FakeWeatherUsecase(const WeatherState.loading());

      await tester.pumpWidget(_buildApp(fakeNotifier));

      expect(find.text('Hourly forecast'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Weather Tracker'), findsOneWidget);
    });

    testWidgets('disables refresh button while loading', (tester) async {
      final fakeNotifier = _FakeWeatherUsecase(const WeatherState.loading());

      await tester.pumpWidget(_buildApp(fakeNotifier));

      final refreshButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(refreshButton.onPressed, isNull);
    });

    testWidgets('renders current weather and forecast data', (tester) async {
      final fakeNotifier = _FakeWeatherUsecase(
        WeatherState.success(snapshot: _snapshot()),
      );

      await tester.pumpWidget(_buildApp(fakeNotifier));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Bangkok, TH'), findsAtLeastNWidgets(1));
      expect(find.text('Daily outlook'), findsOneWidget);
      expect(find.text('Warm evening'), findsAtLeastNWidgets(1));
      expect(find.text('Monday'), findsOneWidget);
    });

    testWidgets('applies sunny tone to backdrop', (tester) async {
      final snapshot = _snapshotFor(
        current: _currentWeather(
          condition: 'Clear',
          description: 'clear sky',
          iconCode: '01d',
        ),
      );
      final fakeNotifier = _FakeWeatherUsecase(
        WeatherState.success(snapshot: snapshot),
      );

      await tester.pumpWidget(_buildApp(fakeNotifier));
      await tester.pumpAndSettle();

      final backdrop = tester.widget<Container>(
        find.byKey(const Key('weather-backdrop')),
      );
      final decoration = backdrop.decoration! as BoxDecoration;
      final gradient = decoration.gradient! as LinearGradient;

      expect(
        gradient.colors.first,
        toneForKind(WeatherToneKind.clearDay).backdropColors.first,
      );
    });

    testWidgets('applies rainy tone to backdrop', (tester) async {
      final snapshot = _snapshotFor(
        current: _currentWeather(
          condition: 'Rain',
          description: 'light rain',
          iconCode: '10d',
        ),
      );
      final fakeNotifier = _FakeWeatherUsecase(
        WeatherState.success(snapshot: snapshot),
      );

      await tester.pumpWidget(_buildApp(fakeNotifier));
      await tester.pumpAndSettle();

      final backdrop = tester.widget<Container>(
        find.byKey(const Key('weather-backdrop')),
      );
      final decoration = backdrop.decoration! as BoxDecoration;
      final gradient = decoration.gradient! as LinearGradient;

      expect(
        gradient.colors.first,
        toneForKind(WeatherToneKind.rain).backdropColors.first,
      );
    });

    testWidgets('renders narrow layout without overflow', (tester) async {
      final fakeNotifier = _FakeWeatherUsecase(
        WeatherState.success(snapshot: _snapshot()),
      );

      await tester.pumpWidget(
        _buildAppWithMedia(
          fakeNotifier,
          size: const Size(320, 800),
          textScaler: const TextScaler.linear(1.4),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Feels like 33°'), findsOneWidget);
    });

    testWidgets('uses neutral loading tone before weather arrives', (
      tester,
    ) async {
      final fakeNotifier = _FakeWeatherUsecase(const WeatherState.loading());

      await tester.pumpWidget(_buildApp(fakeNotifier));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, loadingWeatherTone().scaffoldBackground);
    });

    testWidgets('useAnimation hook rebuilds across ticks', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _AnimationTickProbe())),
      );

      expect(find.text('tick:0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 120));
      expect(find.text('tick:0'), findsNothing);
    });

    testWidgets('renders error state with retry action', (tester) async {
      final fakeNotifier = _FakeWeatherUsecase(
        const WeatherState.error(
          errorMessage: 'Unable to load weather right now.',
        ),
      );

      await tester.pumpWidget(_buildApp(fakeNotifier));

      expect(find.text('Weather unavailable'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(fakeNotifier.loadCallCount, 1);
    });
  });
}

Widget _buildApp(_FakeWeatherUsecase fakeNotifier) {
  return _buildAppWithMedia(
    fakeNotifier,
    size: const Size(390, 844),
    textScaler: const TextScaler.linear(1),
  );
}

Widget _buildAppWithMedia(
  _FakeWeatherUsecase fakeNotifier, {
  required Size size,
  required TextScaler textScaler,
}) {
  return ProviderScope(
    overrides: [weatherUsecaseProvider.overrideWith(() => fakeNotifier)],
    child: MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size, textScaler: textScaler),
        child: const WeatherScreen(),
      ),
    ),
  );
}

class _FakeWeatherUsecase extends WeatherUsecase {
  _FakeWeatherUsecase(this._initialState);

  final WeatherState _initialState;
  int loadCallCount = 0;

  @override
  WeatherState build() => _initialState;

  @override
  Future<void> loadWeather() async {
    loadCallCount++;
  }
}

WeatherSnapshot _snapshot() {
  return _snapshotWith();
}

WeatherSnapshot _snapshotWith({CurrentWeather? current}) {
  return WeatherSnapshot(
    locationName: 'Bangkok, TH',
    updatedAt: DateTime.utc(2024, 1, 1, 12),
    current: current ?? _currentWeather(),
    hourly: [
      HourlyForecastItem(
        time: DateTime.utc(2024, 1, 1, 13),
        temperatureCelsius: 30,
        condition: 'Clouds',
        iconCode: '03d',
        precipitationChance: 10,
      ),
    ],
    daily: [
      DailyForecastItem(
        date: DateTime(2024),
        condition: 'Warm evening',
        iconCode: '03d',
        highCelsius: 31,
        lowCelsius: 28,
        precipitationChance: 10,
      ),
    ],
  );
}

WeatherSnapshot _snapshotFor({CurrentWeather? current}) {
  return _snapshotWith(current: current);
}

CurrentWeather _currentWeather({
  String condition = 'Clouds',
  String description = 'Warm evening',
  String iconCode = '03d',
}) {
  return CurrentWeather(
    temperatureCelsius: 30,
    feelsLikeCelsius: 33,
    condition: condition,
    description: description,
    iconCode: iconCode,
    humidityPercent: 68,
    windSpeedKph: 11,
    sunsetAt: DateTime.utc(2024, 1, 1, 18),
    precipitationChance: 24,
  );
}

class _AnimationTickProbe extends HookWidget {
  const _AnimationTickProbe();

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );
    final value = useAnimation(controller);

    useEffect(() {
      controller.forward();
      return null;
    }, [controller]);

    return Text('tick:${(value * 10).floor()}');
  }
}
