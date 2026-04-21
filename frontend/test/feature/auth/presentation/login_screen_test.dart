import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/feature/auth/presentation/login.screen.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('shows validation errors and blocks empty submit', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
      expect(fakeNotifier.emailSignInCallCount, 0);
    });

    testWidgets('submits trimmed email and password', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.enterText(
        find.byType(TextField).at(0),
        ' test@example.com ',
      );
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(fakeNotifier.lastEmail, 'test@example.com');
      expect(fakeNotifier.lastPassword, 'password123');
      expect(fakeNotifier.emailSignInCallCount, 1);
    });

    testWidgets('renders top-level auth error message', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Invalid email or password',
        ),
      );

      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      expect(find.text('Invalid email or password'), findsOneWidget);
    });

    testWidgets('shows loading indicator and disables sign in button', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        const AuthState(status: AuthStatus.authenticating),
      );

      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      final signInButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );

      expect(signInButton.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('hides google button when provider says unsupported', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      expect(find.text('Continue with Google'), findsNothing);
    });
  });
}

Widget _buildTestApp({
  required _FakeAuthUsecase fakeNotifier,
  required bool showGoogleButton,
}) {
  return ProviderScope(
    overrides: [
      authUsecaseProvider.overrideWith(() => fakeNotifier),
      isMobileGoogleSignInSupportedProvider.overrideWithValue(showGoogleButton),
    ],
    child: const MaterialApp(home: LoginScreen()),
  );
}

class _FakeAuthUsecase extends AuthUsecase {
  _FakeAuthUsecase(this._initialState);

  final AuthState _initialState;
  int emailSignInCallCount = 0;
  String? lastEmail;
  String? lastPassword;

  @override
  AuthState build() => _initialState;

  @override
  void clearError() {}

  @override
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    emailSignInCallCount++;
    lastEmail = email;
    lastPassword = password;
  }
}
