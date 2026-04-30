import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/calendar_background_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/calendar_background_repository.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/calendar_background_usecase.dart';

void main() {
  group('CalendarBackgroundUsecase', () {
    late _FakeCalendarBackgroundRepository fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = _FakeCalendarBackgroundRepository(
        initialImagePath: '/tmp/initial-bg.jpg',
      );

      container = ProviderContainer(
        overrides: [
          calendarBackgroundRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('loads initial calendar background', () async {
      expect(
        await container.read(calendarBackgroundUsecaseProvider.future),
        '/tmp/initial-bg.jpg',
      );
    });

    test('setCalendarBackground persists and updates state', () async {
      await container.read(calendarBackgroundUsecaseProvider.future);

      await container
          .read(calendarBackgroundUsecaseProvider.notifier)
          .setCalendarBackground('/tmp/updated-bg.jpg');

      expect(fakeRepository.imagePath, '/tmp/updated-bg.jpg');
      expect(
        container.read(calendarBackgroundUsecaseProvider).asData?.value,
        '/tmp/updated-bg.jpg',
      );
    });

    test('clearCalendarBackground removes saved image and updates state', () async {
      await container.read(calendarBackgroundUsecaseProvider.future);

      await container
          .read(calendarBackgroundUsecaseProvider.notifier)
          .clearCalendarBackground();

      expect(fakeRepository.imagePath, isNull);
      expect(
        container.read(calendarBackgroundUsecaseProvider).asData?.value,
        isNull,
      );
    });
  });
}

class _FakeCalendarBackgroundRepository implements CalendarBackgroundRepository {
  _FakeCalendarBackgroundRepository({this.initialImagePath})
    : imagePath = initialImagePath;

  final String? initialImagePath;
  String? imagePath;

  @override
  Future<void> clearCalendarBackground() async {
    imagePath = null;
  }

  @override
  Future<String?> loadCalendarBackground() async {
    return imagePath;
  }

  @override
  Future<void> setCalendarBackground(String imagePath) async {
    this.imagePath = imagePath;
  }
}
