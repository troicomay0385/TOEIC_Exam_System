import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:toeic_exam_mobile/models/exam_model.dart';
import 'package:toeic_exam_mobile/models/option_model.dart';
import 'package:toeic_exam_mobile/models/question_model.dart';
import 'package:toeic_exam_mobile/providers/exam_provider.dart';
import 'package:toeic_exam_mobile/screens/exam_taking_screen.dart';
import 'package:toeic_exam_mobile/screens/exam_result_screen.dart';

void main() {
  group('1. Đồng bộ số lượng câu hỏi thực tế', () {
    test('ExamModel synchronizes totalQuestions with questions list length', () {
      final mockQuestions = List.generate(
        10,
        (i) => QuestionModel(
          id: i + 1,
          questionNumber: 101 + i,
          content: 'Question ${i + 1}',
          correctAnswer: 'A',
          options: [
            OptionModel(label: 'A', content: 'Opt A'),
            OptionModel(label: 'B', content: 'Opt B'),
          ],
        ),
      );

      final exam = ExamModel(
        id: 1,
        title: 'Test Exam',
        totalQuestions: 100, // initially specified 100
        questions: mockQuestions, // actual list has 10
      );

      expect(exam.questionCount, 10);

      // JSON parsing test
      final json = {
        'id': 2,
        'title': 'API Exam',
        'totalQuestions': 100,
        'questions': mockQuestions.map((q) => q.toJson()).toList(),
      };
      final fromJsonExam = ExamModel.fromJson(json);
      expect(fromJsonExam.totalQuestions, 10);
      expect(fromJsonExam.questionCount, 10);
    });
  });

  group('2. Chức năng Nộp bài sớm trên ExamTakingScreen', () {
    testWidgets('Displays red Nop bai button and confirmation dialog', (WidgetTester tester) async {
      final provider = ExamProvider();

      // Start exam with fallback (10 questions)
      await provider.startExam(1);

      await tester.pumpWidget(
        ChangeNotifierProvider<ExamProvider>.value(
          value: provider,
          child: const MaterialApp(
            home: ExamTakingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify progress counter shows 1/100
      expect(find.text('1/100'), findsOneWidget);

      // 2. Verify red 'Nộp bài' button in header
      final nopBaiButton = find.widgetWithText(ElevatedButton, 'Nộp bài');
      expect(nopBaiButton, findsOneWidget);

      // 3. Tap 'Nộp bài' button
      await tester.tap(nopBaiButton);
      await tester.pumpAndSettle();

      // 4. Verify confirmation dialog
      expect(find.text('Xác nhận nộp bài'), findsOneWidget);
      expect(
        find.text(
          'Bạn có chắc chắn muốn nộp bài thi ngay bây giờ không? Các câu hỏi chưa chọn sẽ được tính là bỏ qua.',
        ),
        findsOneWidget,
      );
      expect(find.text('Làm tiếp'), findsOneWidget);
      expect(find.text('Đồng ý nộp'), findsOneWidget);

      // 5. Tap 'Làm tiếp' closes dialog
      await tester.tap(find.text('Làm tiếp'));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận nộp bài'), findsNothing);

      // 6. Tap 'Nộp bài' again and confirm with 'Đồng ý nộp'
      await tester.tap(nopBaiButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đồng ý nộp'));
      await tester.pumpAndSettle();

      // 7. Verify transition to ExamResultScreen and display of 0/100
      expect(find.byType(ExamResultScreen), findsOneWidget);
      expect(find.text('0/100'), findsOneWidget);
    });
  });
}
