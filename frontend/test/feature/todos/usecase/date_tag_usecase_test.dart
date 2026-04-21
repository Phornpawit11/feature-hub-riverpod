import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/utils/date_utils.dart';
import 'package:todos_riverpod/src/feature/todos/data/providers/date_tag_repository_provider.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag_repository.dart';
import 'package:todos_riverpod/src/feature/todos/domain/tagged_date.dart';
import 'package:todos_riverpod/src/feature/todos/usecase/date_tag_usecase.dart';

void main() {
  group('DateTagUsecase', () {
    late _FakeDateTagRepository fakeRepository;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = _FakeDateTagRepository(
        tags: [DateTag(id: 'work', name: 'Work', colorValue: 'FF5B8DEF')],
        taggedDates: [],
      );

      container = ProviderContainer(
        overrides: [
          dateTagRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('loads initial tags and tagged dates', () async {
      final state = await container.read(dateTagUsecaseProvider.future);

      expect(state.tags, hasLength(1));
      expect(state.tags.single.name, 'Work');
      expect(state.taggedDates, isEmpty);
    });

    test('creates a global tag', () async {
      await container.read(dateTagUsecaseProvider.future);

      await container
          .read(dateTagUsecaseProvider.notifier)
          .createTag(name: 'Personal', colorValue: 'FF26A69A');

      final state = await container.read(dateTagUsecaseProvider.future);
      expect(state.tags.map((tag) => tag.name), contains('Personal'));
    });

    test('assigns a tag to a date', () async {
      await container.read(dateTagUsecaseProvider.future);

      await container
          .read(dateTagUsecaseProvider.notifier)
          .assignTagToDate(DateTime(2026, 4, 10, 20, 30), 'work');

      final state = await container.read(dateTagUsecaseProvider.future);

      expect(state.assignedTagByDate[DateTime(2026, 4, 10)]?.name, 'Work');
    });

    test('creates and assigns a new tag in one action', () async {
      await container.read(dateTagUsecaseProvider.future);

      await container
          .read(dateTagUsecaseProvider.notifier)
          .createTagAndAssignToDate(
            date: DateTime(2026, 4, 11),
            name: 'Study',
            colorValue: 'FFFFB020',
          );

      final state = await container.read(dateTagUsecaseProvider.future);
      expect(state.tags.map((tag) => tag.name), contains('Study'));
      expect(state.assignedTagByDate[DateTime(2026, 4, 11)]?.name, 'Study');
    });

    test('removes an assigned tag from a date', () async {
      await container.read(dateTagUsecaseProvider.future);
      await container
          .read(dateTagUsecaseProvider.notifier)
          .assignTagToDate(DateTime(2026, 4, 12), 'work');

      await container
          .read(dateTagUsecaseProvider.notifier)
          .removeTagFromDate(DateTime(2026, 4, 12));

      final state = await container.read(dateTagUsecaseProvider.future);
      expect(
        state.assignedTagByDate.containsKey(DateTime(2026, 4, 12)),
        isFalse,
      );
    });

    test('deleting a tag clears dangling tagged dates', () async {
      await container.read(dateTagUsecaseProvider.future);
      await container
          .read(dateTagUsecaseProvider.notifier)
          .assignTagToDate(DateTime(2026, 4, 13), 'work');

      await container.read(dateTagUsecaseProvider.notifier).deleteTag('work');

      final state = await container.read(dateTagUsecaseProvider.future);
      expect(state.tags, isEmpty);
      expect(state.assignedTagByDate, isEmpty);
    });

    test('updateTag trims name before persisting', () async {
      await container.read(dateTagUsecaseProvider.future);

      await container
          .read(dateTagUsecaseProvider.notifier)
          .updateTag(
            DateTag(id: 'work', name: '  Deep Work  ', colorValue: 'FF26A69A'),
          );

      final state = await container.read(dateTagUsecaseProvider.future);
      expect(state.tags.single.name, 'Deep Work');
      expect(state.tags.single.colorValue, 'FF26A69A');
    });
  });
}

class _FakeDateTagRepository implements DateTagRepository {
  _FakeDateTagRepository({
    required List<DateTag> tags,
    required List<TaggedDate> taggedDates,
  }) : _tags = List.of(tags),
       _taggedDates = List.of(taggedDates);

  final List<DateTag> _tags;
  final List<TaggedDate> _taggedDates;

  @override
  Future<void> assignTagToDate(DateTime date, String tagId) async {
    final key = dateStorageKey(date);
    _taggedDates.removeWhere((taggedDate) => taggedDate.id == key);
    _taggedDates.add(
      TaggedDate(id: key, date: normalizeDate(date), tagId: tagId),
    );
  }

  @override
  Future<void> createTag(DateTag tag) async {
    _tags.add(tag);
  }

  @override
  Future<void> deleteTag(String tagId) async {
    _tags.removeWhere((tag) => tag.id == tagId);
    _taggedDates.removeWhere((taggedDate) => taggedDate.tagId == tagId);
  }

  @override
  Future<List<DateTag>> getDateTags() async {
    return List.unmodifiable(_tags);
  }

  @override
  Future<List<TaggedDate>> getTaggedDates() async {
    return List.unmodifiable(_taggedDates);
  }

  @override
  Future<void> removeTagFromDate(DateTime date) async {
    _taggedDates.removeWhere(
      (taggedDate) => taggedDate.id == dateStorageKey(date),
    );
  }

  @override
  Future<void> updateTag(DateTag tag) async {
    final index = _tags.indexWhere((existing) => existing.id == tag.id);
    if (index == -1) return;
    _tags[index] = tag;
  }
}
