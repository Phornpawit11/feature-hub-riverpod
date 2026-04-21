DateTime normalizeDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

String dateStorageKey(DateTime date) {
  final normalized = normalizeDate(date);
  final year = normalized.year.toString().padLeft(4, '0');
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
