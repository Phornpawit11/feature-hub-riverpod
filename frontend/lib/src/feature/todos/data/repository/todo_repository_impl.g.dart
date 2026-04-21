// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoRepositoryImpl)
const todoRepositoryImplProvider = TodoRepositoryImplProvider._();

final class TodoRepositoryImplProvider
    extends $AsyncNotifierProvider<TodoRepositoryImpl, void> {
  const TodoRepositoryImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoRepositoryImplProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryImplHash();

  @$internal
  @override
  TodoRepositoryImpl create() => TodoRepositoryImpl();
}

String _$todoRepositoryImplHash() =>
    r'ed5ede1b442d20a3d2ec98445c6e26485afda3b1';

abstract class _$TodoRepositoryImpl extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
