import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/date_tag_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag_repository.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_state.dart';
import 'package:uuid/uuid.dart';

part 'date_tag_usecase.g.dart';

@riverpod
class DateTagUsecase extends _$DateTagUsecase {
  DateTagRepository get _repository => ref.read(dateTagRepositoryProvider);

  @override
  FutureOr<DateTagState> build() async {
    return _loadState();
  }

  Future<void> assignTagToDate(DateTime date, String tagId) async {
    await _repository.assignTagToDate(date, tagId);
    await _refresh();
  }

  Future<void> createTag({
    required String name,
    required String colorValue,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;
    final currentState = await future;
    final duplicateExists = currentState.tags.any(
      (tag) => tag.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicateExists) return;

    await _repository.createTag(
      DateTag(
        id: const Uuid().v4(),
        name: trimmedName,
        colorValue: colorValue,
      ),
    );
    await _refresh();
  }

  Future<void> createTagAndAssignToDate({
    required DateTime date,
    required String name,
    required String colorValue,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;
    final currentState = await future;
    final duplicateExists = currentState.tags.any(
      (existingTag) =>
          existingTag.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicateExists) return;

    final tag = DateTag(
      id: const Uuid().v4(),
      name: trimmedName,
      colorValue: colorValue,
    );

    await _repository.createTag(tag);
    await _repository.assignTagToDate(normalizeDate(date), tag.id);
    await _refresh();
  }

  Future<void> deleteTag(String tagId) async {
    await _repository.deleteTag(tagId);
    await _refresh();
  }

  Future<void> removeTagFromDate(DateTime date) async {
    await _repository.removeTagFromDate(date);
    await _refresh();
  }

  Future<void> updateTag(DateTag tag) async {
    final trimmedName = tag.name.trim();
    if (trimmedName.isEmpty) return;
    final currentState = await future;
    final duplicateExists = currentState.tags.any(
      (existingTag) =>
          existingTag.id != tag.id &&
          existingTag.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicateExists) return;

    await _repository.updateTag(tag.copyWith(name: trimmedName));
    await _refresh();
  }

  Future<DateTagState> _loadState() async {
    final tags = await _repository.getDateTags();
    final taggedDates = await _repository.getTaggedDates();
    return DateTagState(tags: tags, taggedDates: taggedDates);
  }

  Future<void> _refresh() async {
    state = AsyncData<DateTagState>(await _loadState());
  }
}
