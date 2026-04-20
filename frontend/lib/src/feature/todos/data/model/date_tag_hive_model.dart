import 'package:hive_ce/hive.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';

part 'date_tag_hive_model.g.dart';

@HiveType(typeId: 1)
class DateTagHiveModel extends HiveObject {
  DateTagHiveModel({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  factory DateTagHiveModel.fromDomain(DateTag tag) {
    return DateTagHiveModel(
      id: tag.id,
      name: tag.name,
      colorValue: tag.colorValue,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String colorValue;

  DateTag toDomain() {
    return DateTag(id: id, name: name, colorValue: colorValue);
  }
}
