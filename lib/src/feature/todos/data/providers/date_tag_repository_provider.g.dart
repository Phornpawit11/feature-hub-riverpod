// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_tag_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dateTagRepository)
const dateTagRepositoryProvider = DateTagRepositoryProvider._();

final class DateTagRepositoryProvider
    extends
        $FunctionalProvider<
          DateTagRepository,
          DateTagRepository,
          DateTagRepository
        >
    with $Provider<DateTagRepository> {
  const DateTagRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateTagRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateTagRepositoryHash();

  @$internal
  @override
  $ProviderElement<DateTagRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTagRepository create(Ref ref) {
    return dateTagRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTagRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTagRepository>(value),
    );
  }
}

String _$dateTagRepositoryHash() => r'0b416d23dd470182abedfa3b8a79d22b5966832c';
