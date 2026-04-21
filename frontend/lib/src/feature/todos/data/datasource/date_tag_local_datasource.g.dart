// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_tag_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DateTagLocalDatasource)
const dateTagLocalDatasourceProvider = DateTagLocalDatasourceProvider._();

final class DateTagLocalDatasourceProvider
    extends $AsyncNotifierProvider<DateTagLocalDatasource, void> {
  const DateTagLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateTagLocalDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateTagLocalDatasourceHash();

  @$internal
  @override
  DateTagLocalDatasource create() => DateTagLocalDatasource();
}

String _$dateTagLocalDatasourceHash() =>
    r'9c6e5fbf39866fad456bffcbf56db60a3689b9cb';

abstract class _$DateTagLocalDatasource extends $AsyncNotifier<void> {
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
