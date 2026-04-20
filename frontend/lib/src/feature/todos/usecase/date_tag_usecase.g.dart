// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_tag_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DateTagUsecase)
const dateTagUsecaseProvider = DateTagUsecaseProvider._();

final class DateTagUsecaseProvider
    extends $AsyncNotifierProvider<DateTagUsecase, DateTagState> {
  const DateTagUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateTagUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateTagUsecaseHash();

  @$internal
  @override
  DateTagUsecase create() => DateTagUsecase();
}

String _$dateTagUsecaseHash() => r'2f029017645961ecbe876dc5727415a029930b85';

abstract class _$DateTagUsecase extends $AsyncNotifier<DateTagState> {
  FutureOr<DateTagState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<DateTagState>, DateTagState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DateTagState>, DateTagState>,
              AsyncValue<DateTagState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
