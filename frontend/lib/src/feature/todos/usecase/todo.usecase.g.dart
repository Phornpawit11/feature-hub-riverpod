// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoUsecase)
const todoUsecaseProvider = TodoUsecaseProvider._();

final class TodoUsecaseProvider
    extends $AsyncNotifierProvider<TodoUsecase, List<Todo>> {
  const TodoUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoUsecaseHash();

  @$internal
  @override
  TodoUsecase create() => TodoUsecase();
}

String _$todoUsecaseHash() => r'fba1a1abd58d4ba095cd5e26c5e373e6eb1cd708';

abstract class _$TodoUsecase extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>, List<Todo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Todo>>, List<Todo>>,
              AsyncValue<List<Todo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
