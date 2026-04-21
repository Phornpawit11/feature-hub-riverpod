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

    testWidgets('renders auth error message under password field', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState.unauthenticated,
        emailFailureMessage: 'Invalid email or password',
      );

      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.text('Invalid email or password'), findsOneWidget);
    });

    testWidgets('shows google auth error below google button', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState.unauthenticated,
        googleFailureMessage: 'Google sign-in failed',
      );

      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: true),
      );

      await tester.tap(find.text('Continue with Google'));
      await tester.pump();

      expect(find.text('Google sign-in failed'), findsOneWidget);
      expect(fakeNotifier.googleSignInCallCount, 1);
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

    testWidgets('rejects email with only @ symbol', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);
      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.enterText(find.byType(TextField).at(0), '@');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(fakeNotifier.emailSignInCallCount, 0);
    });

    testWidgets('rejects email without domain', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);
      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.enterText(find.byType(TextField).at(0), 'user@');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(fakeNotifier.emailSignInCallCount, 0);
    });

    testWidgets('rejects email without local part', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);
      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.enterText(find.byType(TextField).at(0), '@domain.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(fakeNotifier.emailSignInCallCount, 0);
    });

    testWidgets('rejects plain text without @ symbol', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);
      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.enterText(find.byType(TextField).at(0), 'notanemail');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(fakeNotifier.emailSignInCallCount, 0);
    });

    testWidgets('accepts valid email format and calls signIn', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);
      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsNothing);
      expect(fakeNotifier.emailSignInCallCount, 1);
    });

    testWidgets('clears email error when user starts typing', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);
      await tester.pumpWidget(
        _buildTestApp(fakeNotifier: fakeNotifier, showGoogleButton: false),
      );

      // trigger error first
      await tester.tap(find.text('Sign in'));
      await tester.pump();
      expect(find.text('Enter a valid email address.'), findsOneWidget);

      // start typing — error should clear
      await tester.enterText(find.byType(TextField).at(0), 'u');
      await tester.pump();
      expect(find.text('Enter a valid email address.'), findsNothing);
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
  _FakeAuthUsecase(
    this._initialState, {
    this.emailFailureMessage,
    this.googleFailureMessage,
  });

  final AuthState _initialState;
  final String? emailFailureMessage;
  final String? googleFailureMessage;
  int emailSignInCallCount = 0;
  int googleSignInCallCount = 0;
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

    if (emailFailureMessage != null) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: emailFailureMessage,
      );
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    googleSignInCallCount++;

    if (googleFailureMessage != null) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: googleFailureMessage,
      );
    }
  }
}
