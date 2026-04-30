import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/presentation/register.screen.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';

void main() {
  group('RegisterScreen', () {
    testWidgets('step 1 blocks continue for invalid email', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

      await tester.tap(_continueButton());
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(fakeNotifier.checkEmailCallCount, 0);
      expect(find.text('Step 1 of 2'), findsOneWidget);
    });

    testWidgets('step 1 stays put when email already exists', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState.unauthenticated,
        checkEmailAvailabilityResult: false,
      );

      await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.tap(_continueButton());
      await tester.pump();

      expect(
        find.text('An account with this email already exists. Please sign in.'),
        findsOneWidget,
      );
      expect(find.text('Step 1 of 2'), findsOneWidget);
      expect(fakeNotifier.checkEmailCallCount, 1);
      expect(fakeNotifier.lastCheckedEmail, 'test@example.com');
    });

    testWidgets('step 1 shows auth exception from email availability check', (
      tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState.unauthenticated,
        checkEmailError: const AuthException(
          'Unable to verify email right now.',
        ),
      );

      await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.tap(_continueButton());
      await tester.pump();

      expect(find.text('Unable to verify email right now.'), findsOneWidget);
      expect(find.text('Step 1 of 2'), findsOneWidget);
    });

    testWidgets('step 1 advances to step 2 when email is available', (
      tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.tap(_continueButton());
      await tester.pump();

      expect(find.text('Step 2 of 2'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
    });

    testWidgets('step 2 validates empty fields and password mismatch', (
      tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.tap(_continueButton());
      await tester.pump();

      await tester.tap(_createAccountButton());
      await tester.pump();

      expect(find.text('Enter your name.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
      expect(find.text('Confirm your password.'), findsOneWidget);
      expect(fakeNotifier.registerCallCount, 0);

      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password456');
      await tester.tap(_createAccountButton());
      await tester.pump();

      expect(find.text('Passwords do not match.'), findsOneWidget);
      expect(fakeNotifier.registerCallCount, 0);
    });

    testWidgets('step 2 submits trimmed registration values', (tester) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

      await tester.enterText(
        find.byType(TextField).first,
        ' test@example.com ',
      );
      await tester.tap(_continueButton());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), ' Test User ');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.tap(_createAccountButton());
      await tester.pump();

      expect(fakeNotifier.lastDisplayName, 'Test User');
      expect(fakeNotifier.lastEmail, 'test@example.com');
      expect(fakeNotifier.lastPassword, 'password123');
      expect(fakeNotifier.registerCallCount, 1);
    });

    testWidgets(
      'back returns to step 1 and changing email clears detail data',
      (tester) async {
        final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

        await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

        await tester.enterText(
          find.byType(TextField).first,
          'first@example.com',
        );
        await tester.tap(_continueButton());
        await tester.pump();

        await tester.enterText(find.byType(TextField).at(0), 'Test User');
        await tester.enterText(find.byType(TextField).at(1), 'password123');
        await tester.enterText(find.byType(TextField).at(2), 'password123');

        await tester.tap(find.widgetWithText(OutlinedButton, 'Back'));
        await tester.pump();

        expect(find.text('Step 1 of 2'), findsOneWidget);

        await tester.enterText(
          find.byType(TextField).first,
          'second@example.com',
        );
        await tester.tap(_continueButton());
        await tester.pump();

        expect(find.text('Step 2 of 2'), findsOneWidget);
        expect(
          tester
              .widget<TextField>(find.byType(TextField).at(0))
              .controller!
              .text,
          isEmpty,
        );
        expect(
          tester
              .widget<TextField>(find.byType(TextField).at(1))
              .controller!
              .text,
          isEmpty,
        );
        expect(
          tester
              .widget<TextField>(find.byType(TextField).at(2))
              .controller!
              .text,
          isEmpty,
        );
      },
    );

    testWidgets('duplicate email from register returns to step 1', (
      tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState.unauthenticated,
        registerFailureMessage:
            'An account with this email already exists. Please sign in.',
      );

      await tester.pumpWidget(_buildTestApp(fakeNotifier: fakeNotifier));

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.tap(_continueButton());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.tap(_createAccountButton());
      await tester.pump();

      expect(find.text('Step 1 of 2'), findsOneWidget);
      expect(
        find.text('An account with this email already exists. Please sign in.'),
        findsOneWidget,
      );
    });
  });
}

Finder _continueButton() {
  return find.widgetWithText(FilledButton, 'Continue');
}

Finder _createAccountButton() {
  return find.widgetWithText(FilledButton, 'Create account');
}

Widget _buildTestApp({required _FakeAuthUsecase fakeNotifier}) {
  return ProviderScope(
    overrides: [authUsecaseProvider.overrideWith(() => fakeNotifier)],
    child: const MaterialApp(home: RegisterScreen()),
  );
}

class _FakeAuthUsecase extends AuthUsecase {
  _FakeAuthUsecase(
    this._initialState, {
    this.checkEmailAvailabilityResult = true,
    this.checkEmailError,
    this.registerFailureMessage,
  });

  final AuthState _initialState;
  final bool checkEmailAvailabilityResult;
  final AuthException? checkEmailError;
  final String? registerFailureMessage;
  int checkEmailCallCount = 0;
  int registerCallCount = 0;
  String? lastCheckedEmail;
  String? lastDisplayName;
  String? lastEmail;
  String? lastPassword;

  @override
  AuthState build() => _initialState;

  @override
  void clearError() {}

  @override
  Future<bool> checkEmailAvailability({required String email}) async {
    checkEmailCallCount++;
    lastCheckedEmail = email;

    if (checkEmailError != null) {
      throw checkEmailError!;
    }

    return checkEmailAvailabilityResult;
  }

  @override
  Future<void> registerWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
  }) async {
    registerCallCount++;
    lastDisplayName = displayName;
    lastEmail = email;
    lastPassword = password;

    if (registerFailureMessage != null) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: registerFailureMessage,
      );
    }
  }
}
