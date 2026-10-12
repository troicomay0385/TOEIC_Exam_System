import 'package:flutter_test/flutter_test.dart';
import 'package:toeic_exam_mobile/main.dart';

void main() {
  testWidgets('App renders TOEIC exam list screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ToeicExamApp());
    await tester.pumpAndSettle();

    expect(find.text('Danh sách đề thi TOEIC'), findsOneWidget);
  });
}
