import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/todo_route_params.dart';

void main() {
  group('TodoRouteParams', () {
    test('parses focused month and selected date from widget uri', () {
      final uri = Uri.parse(
        'featurehub:///todo?focusedMonth=2026-04-01&selectedDate=2026-04-10',
      );

      final params = TodoRouteParams.fromUri(uri);

      expect(params.focusedMonth, DateTime(2026, 4));
      expect(params.selectedDate, DateTime(2026, 4, 10));
    });

    test('serializes widget uri with stable todo route query parameters', () {
      final params = TodoRouteParams(
        focusedMonth: DateTime(2026, 4),
        selectedDate: DateTime(2026, 4, 10),
      );

      final uri = params.toWidgetUri();

      expect(uri.scheme, TodoRouteParams.widgetUrlScheme);
      expect(uri.path, '/todo');
      expect(uri.queryParameters['focusedMonth'], '2026-04-01');
      expect(uri.queryParameters['selectedDate'], '2026-04-10');
    });
  });
}
