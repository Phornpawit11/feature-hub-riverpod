import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';

abstract class DateTagRepository {
  Future<List<DateTag>> getDateTags();
  Future<List<TaggedDate>> getTaggedDates();
  Future<void> createTag(DateTag tag);
  Future<void> updateTag(DateTag tag);
  Future<void> deleteTag(String tagId);
  Future<void> assignTagToDate(DateTime date, String tagId);
  Future<void> removeTagFromDate(DateTime date);
}
