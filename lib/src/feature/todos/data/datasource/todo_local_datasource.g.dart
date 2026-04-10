// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoLocalDatasource)
const todoLocalDatasourceProvider = TodoLocalDatasourceProvider._();

final class TodoLocalDatasourceProvider
    extends $AsyncNotifierProvider<TodoLocalDatasource, void> {
  const TodoLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoLocalDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoLocalDatasourceHash();

  @$internal
  @override
  TodoLocalDatasource create() => TodoLocalDatasource();
}

String _$todoLocalDatasourceHash() =>
    r'75311959685ef5f4f4d9642332c4f5827cabf826';

abstract class _$TodoLocalDatasource extends $AsyncNotifier<void> {
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
