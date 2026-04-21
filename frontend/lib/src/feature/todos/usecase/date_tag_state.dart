import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';

class DateTagState {
  const DateTagState({required this.tags, required this.taggedDates});

  final List<DateTag> tags;
  final List<TaggedDate> taggedDates;

  Map<String, DateTag> get tagById => {for (final tag in tags) tag.id: tag};

  Map<DateTime, DateTag> get assignedTagByDate {
    final tagsById = tagById;
    return {
      for (final taggedDate in taggedDates)
        normalizeDate(taggedDate.date): tagsById[taggedDate.tagId]!,
    };
  }
}
