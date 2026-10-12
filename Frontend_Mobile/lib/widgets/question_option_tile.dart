import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/option_model.dart';

/// Option Tile reflecting Figma Frame 14:64 and Frame 14:80
/// Displays choices A, B, C, D and turns green (#45C486) upon selection
class QuestionOptionTile extends StatelessWidget {
  final OptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  const QuestionOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.cardSelected : AppColors.cardDefault,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppColors.brandGreen : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.cardSelected.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          else
            const BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Option Letter Circle (A / B / C / D)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.optionCircleSelected
                        : AppColors.optionCircleBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      option.label,
                      style: isSelected
                          ? AppTextStyles.optionLetterSelected
                          : AppTextStyles.optionLetter,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Option Content Text
                Expanded(
                  child: Text(
                    option.content,
                    style: isSelected
                        ? AppTextStyles.optionContentSelected
                        : AppTextStyles.optionContent,
                  ),
                ),

                // Trailing Checkmark Icon when Selected (Figma check / 24 / Outline)
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.textWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.cardSelected,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
