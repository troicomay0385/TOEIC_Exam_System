import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/exam_result_model.dart';
import '../models/question_model.dart';
import '../widgets/passage_card.dart';

/// Screen allowing users to review all answered questions and check correct answers
class ExamReviewScreen extends StatefulWidget {
  final ExamResultModel result;

  const ExamReviewScreen({
    super.key,
    required this.result,
  });

  @override
  State<ExamReviewScreen> createState() => _ExamReviewScreenState();
}

class _ExamReviewScreenState extends State<ExamReviewScreen> {
  String _filter = 'ALL'; // 'ALL', 'CORRECT', 'WRONG'

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final questions = result.questions;

    final filteredQuestions = questions.where((q) {
      final userAns = result.userAnswers[q.id];
      final isCorrect = userAns != null &&
          userAns.trim().toUpperCase() == q.correctAnswer.trim().toUpperCase();
      final isSkipped = userAns == null || userAns.isEmpty;

      if (_filter == 'CORRECT') return isCorrect;
      if (_filter == 'WRONG') return !isCorrect && !isSkipped;
      if (_filter == 'SKIPPED') return isSkipped;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      appBar: AppBar(
        backgroundColor: AppColors.canvasBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Xem lại đáp án',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Chips Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('ALL', 'Tất cả (${questions.length})'),
                const SizedBox(width: 8),
                _buildFilterChip('CORRECT', 'Đúng (${result.correctCount})'),
                const SizedBox(width: 8),
                _buildFilterChip('WRONG', 'Sai (${result.wrongCount})'),
                if (result.unansweredCount > 0) ...[
                  const SizedBox(width: 8),
                  _buildFilterChip('SKIPPED', 'Chưa làm (${result.unansweredCount})'),
                ],
              ],
            ),
          ),

          // Questions List
          Expanded(
            child: filteredQuestions.isEmpty
                ? Center(
                    child: Text(
                      'Không có câu hỏi phù hợp bộ lọc.',
                      style: TextStyle(
                        color: AppColors.textNavy.withValues(alpha: 0.7),
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: filteredQuestions.length,
                    itemBuilder: (context, index) {
                      final q = filteredQuestions[index];
                      final userAns = result.userAnswers[q.id];
                      final isCorrect = userAns != null &&
                          userAns.trim().toUpperCase() ==
                              q.correctAnswer.trim().toUpperCase();

                      return _buildReviewCard(q, userAns, isCorrect, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _filter = value;
        });
      },
      selectedColor: AppColors.brandGreen,
      backgroundColor: AppColors.cardDefault,
      labelStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? AppColors.textWhite : AppColors.textDark,
      ),
    );
  }

  Widget _buildReviewCard(
    QuestionModel q,
    String? userAns,
    bool isCorrect,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? AppColors.cardSelected.withValues(alpha: 0.5)
              : AppColors.badgeRed.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.textNavy,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Câu ${q.questionNumber > 0 ? q.questionNumber : index + 1}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.cardSelected.withValues(alpha: 0.15)
                      : AppColors.badgeRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      size: 15,
                      color: isCorrect
                          ? AppColors.cardSelected
                          : AppColors.badgeRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCorrect ? 'Chính xác' : (userAns == null ? 'Chưa làm' : 'Sai'),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isCorrect
                            ? AppColors.cardSelected
                            : AppColors.badgeRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Passage if available
          if (q.hasPassage) ...[
            const SizedBox(height: 12),
            PassageCard(
              passageContent: q.passageContent!,
              partName: q.partCategory,
            ),
          ],

          const SizedBox(height: 12),

          // Question Content
          Text(
            q.content,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textNavy,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          // Options Breakdown
          ...q.options.map((opt) {
            final isUserChoice = userAns == opt.label;
            final isCorrectChoice = q.correctAnswer == opt.label;

            Color tileBg = AppColors.cardDefault;
            Color borderC = Colors.transparent;
            Color textC = AppColors.textDark;
            Widget? trailingIcon;

            if (isCorrectChoice) {
              tileBg = AppColors.cardSelected.withValues(alpha: 0.15);
              borderC = AppColors.cardSelected;
              textC = AppColors.cardSelectedDark;
              trailingIcon = const Icon(
                Icons.check_circle_rounded,
                color: AppColors.cardSelected,
                size: 20,
              );
            } else if (isUserChoice) {
              tileBg = AppColors.badgeRed.withValues(alpha: 0.1);
              borderC = AppColors.badgeRed;
              textC = AppColors.badgeRed;
              trailingIcon = const Icon(
                Icons.close_rounded,
                color: AppColors.badgeRed,
                size: 20,
              );
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: tileBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderC, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCorrectChoice
                          ? AppColors.cardSelected
                          : (isUserChoice
                              ? AppColors.badgeRed
                              : AppColors.optionCircleBg),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        opt.label,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: (isCorrectChoice || isUserChoice)
                              ? AppColors.textWhite
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      opt.content,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textC,
                      ),
                    ),
                  ),
                  ?trailingIcon,
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
