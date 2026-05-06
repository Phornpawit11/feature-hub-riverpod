import 'package:todos_riverpod/src/core/utils/date_utils.dart';

class TodoRouteParams {
  const TodoRouteParams({
    required this.focusedMonth,
    required this.selectedDate,
  });

  static const String focusedMonthKey = 'focusedMonth';
  static const String selectedDateKey = 'selectedDate';
  static const String widgetUrlScheme = 'featurehub';

  final DateTime focusedMonth;
  final DateTime selectedDate;

  factory TodoRouteParams.fromUri(Uri uri) {
    final selectedDate =
        _parseDate(uri.queryParameters[selectedDateKey]) ?? normalizeDate(DateTime.now());
    final focusedMonth =
        _parseDate(uri.queryParameters[focusedMonthKey]) ??
        DateTime(selectedDate.year, selectedDate.month);

    return TodoRouteParams(
      focusedMonth: DateTime(focusedMonth.year, focusedMonth.month),
      selectedDate: normalizeDate(selectedDate),
    );
  }

  Uri toWidgetUri() {
    return Uri(
      scheme: widgetUrlScheme,
      path: '/todo',
      queryParameters: <String, String>{
        focusedMonthKey: _formatDate(focusedMonth),
        selectedDateKey: _formatDate(selectedDate),
      },
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.trim());
  }

  static String _formatDate(DateTime date) {
    final normalized = normalizeDate(date);
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
