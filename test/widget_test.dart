import 'package:flutter_test/flutter_test.dart';
import 'package:toolspark_mobile/main.dart';

void main() {
  testWidgets('ToolSpark AI app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const ToolSparkApp());
    expect(find.text('ToolSpark'), findsOneWidget);
  });
}
