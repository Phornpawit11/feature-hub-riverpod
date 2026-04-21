// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthUsecase)
const authUsecaseProvider = AuthUsecaseProvider._();

final class AuthUsecaseProvider
    extends $NotifierProvider<AuthUsecase, AuthState> {
  const AuthUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authUsecaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authUsecaseHash();

  @$internal
  @override
  AuthUsecase create() => AuthUsecase();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authUsecaseHash() => r'08e650744a568a690ac703e6b7940801a03189bf';

abstract class _$AuthUsecase extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
