import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return ref.watch(authRepositoryImplProvider.notifier);
}
