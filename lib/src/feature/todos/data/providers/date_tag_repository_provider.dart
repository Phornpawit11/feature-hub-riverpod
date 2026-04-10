import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/todos/data/repository/date_tag_repository_impl.dart';
import 'package:todos_riverpod/src/feature/todos/domain/date_tag_repository.dart';

part 'date_tag_repository_provider.g.dart';

@riverpod
DateTagRepository dateTagRepository(Ref ref) {
  return ref.watch(dateTagRepositoryImplProvider.notifier);
}
