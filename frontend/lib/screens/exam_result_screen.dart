import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/exam_result_model.dart';
import '../providers/exam_provider.dart';
import 'exam_review_screen.dart';

/// Màn 4 trên Figma - Mục 7 Báo cáo: ExamResultScreen
/// - Tự động chấm điểm, hiển thị tổng điểm (ví dụ: 850/990)
/// - Thống kê chi tiết: Số câu đúng (85/100), Số câu sai
/// - Nút 'Xem lại đáp án' và nút 'Về trang chủ' (OKAY)
class ExamResultScreen extends StatelessWidget {
  final ExamResultModel result;

  const ExamResultScreen({
    super.key,
    required this.result,
  });

  void _goHome(BuildContext context) {
    context.read<ExamProvider>().resetTakingExam();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _goHome(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.canvasBackground,
        appBar: AppBar(
          backgroundColor: AppColors.canvasBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textDark),
            onPressed: () => _goHome(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.textDark),
              onPressed: () => _goHome(context),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Gift Box Graphic from Figma (Node #14:515)
                SvgPicture.asset(
                  'assets/images/gift_box.svg',
                  width: 144,
                  height: 151,
                  fit: BoxFit.contain,
                  semanticsLabel: 'Hộp quà kết quả bài thi',
                ),
                const SizedBox(height: 20),

                // Result Title (Figma Frame 14:434)
                Text(
                  'Results of ${result.examTitle}',
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Hoàn thành lúc ${result.completedAt.hour.toString().padLeft(2, '0')}:${result.completedAt.minute.toString().padLeft(2, '0')} ngày ${result.completedAt.day}/${result.completedAt.month}/${result.completedAt.year}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 28),

                // Result Card (Figma Group 14:535 & 14:444)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardDefault,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ROW 1: SCORE GAINED (Figma Group 14:533)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.brandGreen.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.stars_rounded,
                                color: AppColors.brandGreen,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'SCORE GAINED',
                                style: AppTextStyles.resultStatLabel,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${result.scaledScore}',
                                  style: AppTextStyles.resultStatNumber.copyWith(
                                    fontSize: 24,
                                    color: AppColors.brandGreen,
                                  ),
                                ),
                                const Text(
                                  ' / 990',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Divider (Figma Line 14:534)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                        indent: 20,
                        endIndent: 20,
                      ),

                      // ROW 2: CORRECT PREDICTIONS / SỐ CÂU ĐÚNG (Figma Group 14:464)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.cardSelected.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.cardSelected,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'CORRECT PREDICTIONS',
                                style: AppTextStyles.resultStatLabel,
                              ),
                            ),
                            Text(
                              '${result.correctCount}/100',
                              style: AppTextStyles.resultStatNumber.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                        indent: 20,
                        endIndent: 20,
                      ),

                      // ROW 3: SỐ CÂU SAI & THỜI GIAN LÀM BÀI
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.badgeRed.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.cancel_rounded,
                                color: AppColors.badgeRed,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'SỐ CÂU SAI',
                                style: AppTextStyles.resultStatLabel,
                              ),
                            ),
                            Text(
                              '${result.wrongCount} câu',
                              style: AppTextStyles.resultStatNumber.copyWith(
                                color: AppColors.badgeRed,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                        indent: 20,
                        endIndent: 20,
                      ),

                      // ROW 3.5: CÂU BỎ QUA (NẾU CÓ)
                      if (result.unansweredCount > 0) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.textMuted.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.help_outline_rounded,
                                  color: AppColors.textMuted,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Text(
                                  'CÂU BỎ QUA (CHƯA LÀM)',
                                  style: AppTextStyles.resultStatLabel,
                                ),
                              ),
                              Text(
                                '${result.unansweredCount} câu',
                                style: AppTextStyles.resultStatNumber.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.divider,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ],

                      // ROW 4: THỜI GIAN LÀM BÀI
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.textNavy.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.timer_outlined,
                                color: AppColors.textNavy,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'THỜI GIAN HOÀN THÀNH',
                                style: AppTextStyles.resultStatLabel,
                              ),
                            ),
                            Text(
                              result.formattedTimeSpent,
                              style: AppTextStyles.resultStatNumber.copyWith(
                                color: AppColors.textNavy,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Button: 'Xem lại đáp án'
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ExamReviewScreen(result: result),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textNavy,
                      side: const BorderSide(color: AppColors.textNavy, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Xem lại đáp án',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Button: 'OKAY' / 'Về trang chủ' (Figma Frame 14:472 & 14:474)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => _goHome(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandGreen, // Figma #31CD63
                      foregroundColor: AppColors.textWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'OKAY',
                      style: AppTextStyles.actionButton,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
