// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_sign_in_adapter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(googleSignIn)
const googleSignInProvider = GoogleSignInProvider._();

final class GoogleSignInProvider
    extends $FunctionalProvider<GoogleSignIn, GoogleSignIn, GoogleSignIn>
    with $Provider<GoogleSignIn> {
  const GoogleSignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInHash();

  @$internal
  @override
  $ProviderElement<GoogleSignIn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleSignIn create(Ref ref) {
    return googleSignIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignIn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignIn>(value),
    );
  }
}

String _$googleSignInHash() => r'6b68e7785a816a60cd0c722d8a0ef9c87c7cdc7d';

@ProviderFor(googleSignInAdapter)
const googleSignInAdapterProvider = GoogleSignInAdapterProvider._();

final class GoogleSignInAdapterProvider
    extends
        $FunctionalProvider<
          GoogleSignInAdapter,
          GoogleSignInAdapter,
          GoogleSignInAdapter
        >
    with $Provider<GoogleSignInAdapter> {
  const GoogleSignInAdapterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInAdapterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInAdapterHash();

  @$internal
  @override
  $ProviderElement<GoogleSignInAdapter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleSignInAdapter create(Ref ref) {
    return googleSignInAdapter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignInAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignInAdapter>(value),
    );
  }
}

String _$googleSignInAdapterHash() =>
    r'0c041706a4009023d7ed05956df7b4728a5d6574';

@ProviderFor(isMobileGoogleSignInSupported)
const isMobileGoogleSignInSupportedProvider =
    IsMobileGoogleSignInSupportedProvider._();

final class IsMobileGoogleSignInSupportedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsMobileGoogleSignInSupportedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isMobileGoogleSignInSupportedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isMobileGoogleSignInSupportedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isMobileGoogleSignInSupported(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isMobileGoogleSignInSupportedHash() =>
    r'8cd53f339c7302fd9a9aba20bb91ef68de374436';
