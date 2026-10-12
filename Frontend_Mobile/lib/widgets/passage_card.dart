import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Card to render reading comprehension passages for TOEIC Part 6 and Part 7
class PassageCard extends StatelessWidget {
  final String passageContent;
  final String partName;

  const PassageCard({
    super.key,
    required this.passageContent,
    required this.partName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
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
          // Header banner for Passage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.cardDefault,
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 16,
                  color: AppColors.textNavy,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    partName,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textNavy,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const Text(
                  'Đoạn văn đọc hiểu',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Passage Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: SelectableText(
              passageContent,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
