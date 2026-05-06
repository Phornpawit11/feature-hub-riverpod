class CalendarWidgetDaySnapshot {
  const CalendarWidgetDaySnapshot({
    required this.date,
    required this.isToday,
    required this.isCurrentMonth,
    required this.tagColor,
    required this.tagLabel,
    required this.tagLabelShort,
    required this.todoDotColors,
    required this.deepLinkTarget,
  });

  final String date;
  final bool isToday;
  final bool isCurrentMonth;
  final String? tagColor;
  final String? tagLabel;
  final String? tagLabelShort;
  final List<String> todoDotColors;
  final String deepLinkTarget;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'isToday': isToday,
      'isCurrentMonth': isCurrentMonth,
      'tagColor': tagColor,
      'tagLabel': tagLabel,
      'tagLabelShort': tagLabelShort,
      'todoDotColors': todoDotColors,
      'deepLinkTarget': deepLinkTarget,
    };
  }
}

class CalendarWidgetSnapshot {
  const CalendarWidgetSnapshot({
    required this.schemaVersion,
    required this.year,
    required this.month,
    required this.selectedDate,
    required this.defaultDeepLinkTarget,
    required this.days,
  });

  final int schemaVersion;
  final int year;
  final int month;
  final String selectedDate;
  final String defaultDeepLinkTarget;
  final List<CalendarWidgetDaySnapshot> days;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'schemaVersion': schemaVersion,
      'year': year,
      'month': month,
      'selectedDate': selectedDate,
      'defaultDeepLinkTarget': defaultDeepLinkTarget,
      'days': days.map((CalendarWidgetDaySnapshot day) => day.toJson()).toList(),
    };
  }
}
