import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/widgets/app_drawer.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_notifier.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';

void main() {
  group('AppDrawer', () {
    testWidgets('renders authenticated profile data', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthNotifier(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('falls back gracefully when avatarUrl is null', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthNotifier(
        AuthState(status: AuthStatus.authenticated, user: _testUser()),
      );

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('hides logout for unauthenticated state', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthNotifier(AuthState.unauthenticated);

      await tester.pumpWidget(_buildDrawerHost(fakeNotifier));
      await _openDrawer(tester);

      expect(find.text('Logout'), findsNothing);
      expect(find.text('Your Workspace'), findsOneWidget);
    });

    testWidgets('opens logout confirmation bottom sheet', (
      WidgetTester tester,
    ) async {
      final fakeNotifier = _FakeAuthNotifier(
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
      final fakeNotifier = _FakeAuthNotifier(
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
      final fakeNotifier = _FakeAuthNotifier(
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

Widget _buildDrawerHost(_FakeAuthNotifier fakeNotifier) {
  return ProviderScope(
    overrides: [authNotifierProvider.overrideWith(() => fakeNotifier)],
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

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._initialState);

  final AuthState _initialState;
  int signOutCallCount = 0;

  @override
  AuthState build() => _initialState;

  @override
  Future<void> signOut() async {
    signOutCallCount++;
    state = AuthState.unauthenticated;
  }
}
