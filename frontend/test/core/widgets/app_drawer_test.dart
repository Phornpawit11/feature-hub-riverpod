import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/widgets/app_drawer.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';

void main() {
  group('AppDrawer', () {
    testWidgets('renders authenticated profile data', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Logout', skipOffstage: false), findsOneWidget);
    });

    testWidgets('falls back gracefully when avatarUrl is null', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('hides logout for unauthenticated state', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      expect(find.text('Logout'), findsNothing);
      expect(find.text('Your Workspace'), findsOneWidget);
    });

    testWidgets('authenticated profile card opens edit profile sheet', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      await tester.tap(find.byKey(const Key('profile-card')));
      await tester.pumpAndSettle();

      expect(find.text('Edit your name'), findsOneWidget);
      expect(
        find.text('Choose how your workspace should greet you.'),
        findsOneWidget,
      );
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Test User'), findsNWidgets(2));
    });

    testWidgets('unauthenticated profile card stays display-only', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      await tester.tap(
        find.byKey(const Key('profile-card')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit your name'), findsNothing);
    });

    testWidgets('edit profile validates blank display name', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      await tester.tap(find.byKey(const Key('profile-card')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your name.'), findsOneWidget);
      expect(fakeNotifier.updateDisplayNameCallCount, 0);
    });

    testWidgets(
      'successful profile update closes sheet and refreshes drawer name',
      (WidgetTester tester) async {
        final fakeNotifier = _FakeAuthUsecase(
          AuthState(status: AuthStatus.authenticated, user: _testUser()),
        );

        await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
        await _openDrawer(tester);

        await tester.tap(find.byKey(const Key('profile-card')));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Updated User');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(fakeNotifier.updateDisplayNameCallCount, 1);
        expect(fakeNotifier.lastUpdatedDisplayName, 'Updated User');
        expect(find.text('Edit your name'), findsNothing);
        expect(find.text('Updated User'), findsOneWidget);
      },
    );

    testWidgets(
      'profile update error stays in sheet and preserves current name',
      (WidgetTester tester) async {
        final fakeNotifier = _FakeAuthUsecase(
          AuthState(status: AuthStatus.authenticated, user: _testUser()),
        )..updateDisplayNameError = 'Unable to update profile.';

        await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
        await _openDrawer(tester);

        await tester.tap(find.byKey(const Key('profile-card')));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Updated User');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(fakeNotifier.updateDisplayNameCallCount, 1);
        expect(find.text('Unable to update profile.'), findsOneWidget);
        expect(find.text('Edit your name'), findsOneWidget);
        expect(find.text('Test User'), findsOneWidget);
      },
    );

    testWidgets('opens logout confirmation bottom sheet', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      await _tapLogout(tester);
      await tester.pumpAndSettle();

      expect(find.text('Log out?'), findsOneWidget);
      expect(
        find.text('You\'ll return to the login screen on this device.'),
        findsOneWidget,
      );
      expect(find.text('Log out'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('confirming logout signs out and hides logout afterwards', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      await _tapLogout(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      expect(fakeNotifier.signOutCallCount, 1);

      await _openDrawer(tester);
      expect(find.text('Logout'), findsNothing);
      expect(
        find.text('Sign in to personalize your workspace.'),
        findsOneWidget,
      );
    });

    testWidgets('canceling logout does not sign out', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      await _tapLogout(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(fakeNotifier.signOutCallCount, 0);
      expect(find.text('Log out?'), findsNothing);
      expect(find.text('Logout'), findsOneWidget);
    });
  });
}

Widget _buildDrawerHost(_FakeAuthUsecase fakeNotifier) {
  return ProviderScope(
    overrides: [authUsecaseProvider.overrideWith(() => fakeNotifier)],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                child: const Text('Open drawer'),
              ),
            );
          },
        ),
        endDrawer: const AppDrawer(),
      ),
    ),
  );
}

Future<void> _openDrawer(WidgetTester tester) async {
  await tester.tap(find.text('Open drawer'));
  await tester.pumpAndSettle();
}

Future<void> _tapLogout(WidgetTester tester) async {
  final logoutTile = find.widgetWithText(ListTile, 'Logout');
  await tester.scrollUntilVisible(
    logoutTile,
    120,
    scrollable: find.descendant(
      of: find.byType(AppDrawer),
      matching: find.byType(Scrollable),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(logoutTile, warnIfMissed: false);
}

AuthUser _testUser() {
  return AuthUser(
    id: 'user-1',
    email: 'test@example.com',
    displayName: 'Test User',
    provider: 'google',
  );
}

class _FakeAuthUsecase extends AuthUsecase {
  _FakeAuthUsecase(this._initialState);

  final AuthState _initialState;
  int signOutCallCount = 0;
  int updateDisplayNameCallCount = 0;
  String? lastUpdatedDisplayName;
  String? updateDisplayNameError;

  @override
  AuthState build() => _initialState;

  @override
  Future<bool> updateDisplayName({required String displayName}) async {
    updateDisplayNameCallCount++;
    lastUpdatedDisplayName = displayName;

    if (updateDisplayNameError != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        errorMessage: updateDisplayNameError,
      );
      return false;
    }

    state = state.clearError(
      status: AuthStatus.authenticated,
      user: state.user?.copyWith(displayName: displayName.trim()),
    );
    return true;
  }

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    state = AuthState.unauthenticated;
  }
}
