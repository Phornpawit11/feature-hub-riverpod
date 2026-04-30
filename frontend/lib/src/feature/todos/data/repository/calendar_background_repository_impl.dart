import 'package:todos_riverpod/src/feature/todos/data/datasource/calendar_background_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/domain/calendar_background_repository.dart';

class CalendarBackgroundRepositoryImpl implements CalendarBackgroundRepository {
  const CalendarBackgroundRepositoryImpl(this._datasource);

  final CalendarBackgroundLocalDatasource _datasource;

  @override
  Future<void> clearCalendarBackground() {
    return _datasource.clearCalendarBackground();
  }

  @override
  Future<String?> loadCalendarBackground() {
    return _datasource.loadCalendarBackground();
  }

  @override
  Future<void> setCalendarBackground(String imagePath) {
    return _datasource.setCalendarBackground(imagePath);
  }
}
