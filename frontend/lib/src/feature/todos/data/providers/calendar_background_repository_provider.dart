import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/feature/todos/data/datasource/calendar_background_local_datasource.dart';
import 'package:todos_riverpod/src/feature/todos/data/repository/calendar_background_repository_impl.dart';
import 'package:todos_riverpod/src/feature/todos/domain/calendar_background_repository.dart';

final calendarBackgroundRepositoryProvider =
    Provider<CalendarBackgroundRepository>((ref) {
      final datasource = ref.watch(calendarBackgroundLocalDatasourceProvider);
      return CalendarBackgroundRepositoryImpl(datasource);
    });
