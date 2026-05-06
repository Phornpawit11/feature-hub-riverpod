import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/core/storage/hive_boxes.dart';

final calendarBackgroundLocalDatasourceProvider =
    Provider<CalendarBackgroundLocalDatasource>(
      (ref) => const CalendarBackgroundLocalDatasource(),
    );

class CalendarBackgroundLocalDatasource {
  const CalendarBackgroundLocalDatasource();

  static const String _calendarBackgroundKey = 'calendar_background_image_path';

  Future<String?> loadCalendarBackground() async {
    return Hive.box<String>(HiveBoxes.calendarBackgroundSettings).get(
      _calendarBackgroundKey,
    );
  }

  Future<void> setCalendarBackground(String imagePath) async {
    await Hive.box<String>(
      HiveBoxes.calendarBackgroundSettings,
    ).put(_calendarBackgroundKey, imagePath);
  }

  Future<void> clearCalendarBackground() async {
    await Hive.box<String>(
      HiveBoxes.calendarBackgroundSettings,
    ).delete(_calendarBackgroundKey);
  }
}
