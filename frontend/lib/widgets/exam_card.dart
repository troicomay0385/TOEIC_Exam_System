import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/exam_model.dart';

/// Exam Card component reflecting Figma Frame 102:19 ("Exam list")
class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onStart;

  const ExamCard({
    super.key,
    required this.exam,
    required this.isSelected,
    required this.onSelect,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    // In Figma, selected card has green background (#45C486) while unselected has #F4F3F6
    final backgroundColor = isSelected ? AppColors.cardSelected : AppColors.cardDefault;
    final titleColor = isSelected ? AppColors.textWhite : AppColors.textDark;
    final durationColor = isSelected ? AppColors.textWhite : AppColors.textDark;
    final questionColor = isSelected ? AppColors.textWhite : AppColors.badgeRed;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.brandGreen : AppColors.borderSubtle,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.cardSelected.withValues(alpha: 0.3)
                : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Icon / Circle Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textWhite.withValues(alpha: 0.2)
                        : AppColors.canvasBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: isSelected ? AppColors.textWhite : AppColors.textNavy,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Exam Title & Sub-information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: titleColor,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: durationColor.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${exam.duration} phút',
                            style: AppTextStyles.badgeDuration.copyWith(
                              color: durationColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: durationColor.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.format_list_numbered_rounded,
                            size: 14,
                            color: questionColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '100 câu',
                            style: AppTextStyles.badgeQuestions.copyWith(
                              color: questionColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Action 'Vào thi' Button
                ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? AppColors.textWhite
                        : AppColors.brandGreen,
                    foregroundColor: isSelected
                        ? AppColors.textNavy
                        : AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Vào thi',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.textNavy : AppColors.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
