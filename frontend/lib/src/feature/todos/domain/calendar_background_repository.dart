abstract class CalendarBackgroundRepository {
  Future<String?> loadCalendarBackground();

  Future<void> setCalendarBackground(String imagePath);

  Future<void> clearCalendarBackground();
}
