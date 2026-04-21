// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthRepositoryImpl)
const authRepositoryImplProvider = AuthRepositoryImplProvider._();

final class AuthRepositoryImplProvider
    extends $AsyncNotifierProvider<AuthRepositoryImpl, void> {
  const AuthRepositoryImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryImplProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryImplHash();

  @$internal
  @override
  AuthRepositoryImpl create() => AuthRepositoryImpl();
}

String _$authRepositoryImplHash() =>
    r'e5a2e95db02bb9505905d4df2a040ed9cd129143';

abstract class _$AuthRepositoryImpl extends $AsyncNotifier<void> {
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
