// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_tag_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DateTagRepositoryImpl)
const dateTagRepositoryImplProvider = DateTagRepositoryImplProvider._();

final class DateTagRepositoryImplProvider
    extends $AsyncNotifierProvider<DateTagRepositoryImpl, void> {
  const DateTagRepositoryImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateTagRepositoryImplProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateTagRepositoryImplHash();

  @$internal
  @override
  DateTagRepositoryImpl create() => DateTagRepositoryImpl();
}

String _$dateTagRepositoryImplHash() =>
    r'153e16b7a5ba23b274a534a9e0c8ffc46c7c260f';

abstract class _$DateTagRepositoryImpl extends $AsyncNotifier<void> {
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
