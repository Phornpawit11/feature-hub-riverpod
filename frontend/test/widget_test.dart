import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/my_app.dart';

void main() {
  testWidgets('shows landing screen with todo feature', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Workspace'), findsOneWidget);
    expect(find.text('Available now'), findsOneWidget);
    expect(find.text('Todos'), findsOneWidget);
  });
}
