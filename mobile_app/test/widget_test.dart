import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LocalItineraryPlannerApp());
    expect(find.text('Lên Lịch Trải Nghiệm & Hội Ngộ'), findsOneWidget);
  });
}
