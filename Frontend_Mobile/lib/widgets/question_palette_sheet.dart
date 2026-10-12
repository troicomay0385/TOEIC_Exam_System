import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/question_model.dart';

/// Modal bottom sheet displaying question grid for fast navigation
class QuestionPaletteSheet extends StatelessWidget {
  final List<QuestionModel> questions;
  final Map<int, String> userAnswers;
  final int currentIndex;
  final Function(int) onSelectQuestion;

  const QuestionPaletteSheet({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.currentIndex,
    required this.onSelectQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.canvasBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Title and summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách câu hỏi',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textNavy,
                  ),
                ),
                Text(
                  'Đã làm ${userAnswers.length}/${questions.length}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Grid of questions
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  final isAnswered = userAnswers.containsKey(q.id);
                  final isCurrent = index == currentIndex;

                  Color bgColor;
                  Color textColor;
                  Color borderColor;

                  if (isCurrent) {
                    borderColor = AppColors.textNavy;
                    bgColor = isAnswered
                        ? AppColors.cardSelected
                        : AppColors.textWhite;
                    textColor = isAnswered
                        ? AppColors.textWhite
                        : AppColors.textNavy;
                  } else if (isAnswered) {
                    bgColor = AppColors.cardSelected;
                    borderColor = AppColors.cardSelected;
                    textColor = AppColors.textWhite;
                  } else {
                    bgColor = AppColors.cardDefault;
                    borderColor = AppColors.borderSubtle;
                    textColor = AppColors.textDark;
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onSelectQuestion(index);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: borderColor,
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${q.questionNumber > 0 ? q.questionNumber : index + 1}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                  color: AppColors.cardSelected,
                  label: 'Đã trả lời',
                ),
                _buildLegendItem(
                  color: AppColors.cardDefault,
                  borderColor: AppColors.borderSubtle,
                  label: 'Chưa làm',
                ),
                _buildLegendItem(
                  color: AppColors.textWhite,
                  borderColor: AppColors.textNavy,
                  label: 'Đang xem',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    Color? borderColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: borderColor ?? color,
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
