import 'package:flutter_test/flutter_test.dart';
import 'package:brian_project/app.dart';

void main() {
  testWidgets('Home screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SemesterProjectApp());

    expect(find.text('Brian Project'), findsOneWidget);
    expect(find.text('Open Login'), findsOneWidget);
  });
}
