import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/calendar_background_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/repository/calendar_background_repository_impl.dart';

void main() {
  group('CalendarBackgroundRepositoryImpl', () {
    test('loads saved calendar background from datasource', () async {
      final datasource = _FakeCalendarBackgroundLocalDatasource(
        initialImagePath: '/tmp/saved-bg.jpg',
      );
      final repository = CalendarBackgroundRepositoryImpl(datasource);

      expect(
        await repository.loadCalendarBackground(),
        '/tmp/saved-bg.jpg',
      );
    });

    test('saves and clears calendar background through datasource', () async {
      final datasource = _FakeCalendarBackgroundLocalDatasource();
      final repository = CalendarBackgroundRepositoryImpl(datasource);

      await repository.setCalendarBackground('/tmp/next-bg.jpg');
      expect(datasource.imagePath, '/tmp/next-bg.jpg');

      await repository.clearCalendarBackground();
      expect(datasource.imagePath, isNull);
    });
  });
}

class _FakeCalendarBackgroundLocalDatasource
    extends CalendarBackgroundLocalDatasource {
  _FakeCalendarBackgroundLocalDatasource({this.initialImagePath});

  final String? initialImagePath;
  String? imagePath;

  @override
  Future<void> clearCalendarBackground() async {
    imagePath = null;
  }

  @override
  Future<String?> loadCalendarBackground() async {
    return imagePath ?? initialImagePath;
  }

  @override
  Future<void> setCalendarBackground(String imagePath) async {
    this.imagePath = imagePath;
  }
}
