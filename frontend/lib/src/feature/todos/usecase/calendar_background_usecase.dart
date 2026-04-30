import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/calendar_background_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/calendar_background_repository.dart';

final calendarBackgroundUsecaseProvider =
    AsyncNotifierProvider<CalendarBackgroundUsecase, String?>(
      CalendarBackgroundUsecase.new,
    );

final isMobileCalendarBackgroundPickerSupportedProvider = Provider<bool>((ref) {
  if (kIsWeb) {
    return false;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => true,
    _ => false,
  };
});

class CalendarBackgroundUsecase extends AsyncNotifier<String?> {
  CalendarBackgroundRepository get _repository =>
      ref.read(calendarBackgroundRepositoryProvider);

  @override
  Future<String?> build() {
    return _repository.loadCalendarBackground();
  }

  Future<void> loadCalendarBackground() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.loadCalendarBackground);
  }

  Future<void> setCalendarBackground(String imagePath) async {
    await _repository.setCalendarBackground(imagePath);
    state = AsyncData(imagePath);
  }

  Future<void> clearCalendarBackground() async {
    await _repository.clearCalendarBackground();
    state = const AsyncData<String?>(null);
  }
}
