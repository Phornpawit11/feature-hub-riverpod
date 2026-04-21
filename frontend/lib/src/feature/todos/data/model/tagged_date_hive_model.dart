import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';

part 'tagged_date_hive_model.g.dart';

@HiveType(typeId: 2)
class TaggedDateHiveModel extends HiveObject {
  TaggedDateHiveModel({
    required this.id,
    required this.date,
    required this.tagId,
  });

  factory TaggedDateHiveModel.fromDomain(TaggedDate taggedDate) {
    return TaggedDateHiveModel(
      id: taggedDate.id,
      date: normalizeDate(taggedDate.date),
      tagId: taggedDate.tagId,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String tagId;

  TaggedDate toDomain() {
    return TaggedDate(id: id, date: normalizeDate(date), tagId: tagId);
  }
}
