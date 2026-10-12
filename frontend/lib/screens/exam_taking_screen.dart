import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/exam_provider.dart';
import '../widgets/question_option_tile.dart';
import '../widgets/countdown_timer_widget.dart';
import '../widgets/passage_card.dart';
import '../widgets/question_palette_sheet.dart';
import 'exam_result_screen.dart';

/// Màn 2 và Màn 3 trên Figma - Mục 6 Báo cáo: ExamTakingScreen
/// - Có đồng hồ đếm ngược 75 phút (tự nộp bài khi hết giờ)
/// - Hiển thị câu hỏi Part 5 và Đoạn văn bài đọc Part 6/7
/// - Hiển thị 4 lựa chọn trắc nghiệm A/B/C/D (đổi màu xanh khi user chọn đáp án như Màn 2)
/// - Bộ nút điều hướng: Nút 'CONTINUE' để sang câu tiếp theo (Màn 2) và tự chuyển thành 'FINISH' (Màn 3) khi làm đến câu cuối cùng để Nộp bài
class ExamTakingScreen extends StatefulWidget {
  const ExamTakingScreen({super.key});

  @override
  State<ExamTakingScreen> createState() => _ExamTakingScreenState();
}

class _ExamTakingScreenState extends State<ExamTakingScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _showEarlySubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.assignment_turned_in_rounded, color: AppColors.badgeRed),
            SizedBox(width: 8),
            Text(
              'Xác nhận nộp bài',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textNavy,
              ),
            ),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn nộp bài thi ngay bây giờ không? Các câu hỏi chưa chọn sẽ được tính là bỏ qua.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            height: 1.4,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Làm tiếp',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finishAndSubmit(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.badgeRed,
              foregroundColor: AppColors.textWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Đồng ý nộp',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.assignment_turned_in_rounded, color: AppColors.brandGreen),
            SizedBox(width: 8),
            Text(
              'Xác nhận nộp bài',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textNavy,
              ),
            ),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn nộp bài thi ngay bây giờ không? Các câu hỏi chưa chọn sẽ được tính là bỏ qua.',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            height: 1.4,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Làm tiếp',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finishAndSubmit(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandGreen,
              foregroundColor: AppColors.textWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Đồng ý nộp',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _finishAndSubmit(BuildContext context) {
    final provider = context.read<ExamProvider>();
    final result = provider.submitExam();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ExamResultScreen(result: result),
      ),
    );
  }

  void _confirmQuit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Thoát bài thi?'),
        content: const Text(
          'Tiến trình làm bài hiện tại sẽ không được lưu nếu bạn thoát bây giờ.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Ở lại làm tiếp'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ExamProvider>().resetTakingExam();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.badgeRed,
              foregroundColor: AppColors.textWhite,
            ),
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  void _openQuestionPalette(BuildContext context) {
    final provider = context.read<ExamProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuestionPaletteSheet(
        questions: provider.currentExam?.questions ?? [],
        userAnswers: provider.userAnswers,
        currentIndex: provider.currentQuestionIndex,
        onSelectQuestion: (index) {
          provider.jumpToQuestion(index);
          _scrollToTop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamProvider>(
      builder: (context, provider, child) {
        // Auto-submitted due to time expiration
        if (provider.isAutoSubmitted && provider.latestResult != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ExamResultScreen(result: provider.latestResult!),
                ),
              );
            }
          });
        }

        final currentExam = provider.currentExam;
        final currentQuestion = provider.currentQuestion;

        if (provider.isLoadingExamDetail) {
          return const Scaffold(
            backgroundColor: AppColors.canvasBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.brandGreen),
            ),
          );
        }

        if (currentQuestion == null) {
          return Scaffold(
            backgroundColor: AppColors.canvasBackground,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Không có dữ liệu câu hỏi.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            ),
          );
        }

        final currentIndex = provider.currentQuestionIndex;
        final isLast = provider.isLastQuestion;
        final selectedAnswer = provider.userAnswers[currentQuestion.id];

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _confirmQuit(context);
          },
          child: Scaffold(
            backgroundColor: AppColors.canvasBackground,
            // TOP HEADER matching Figma Frame 14:305
            appBar: AppBar(
              backgroundColor: AppColors.canvasBackground,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              title: Row(
                children: [
                  // Countdown Timer Pill (Figma Group 14:310)
                  CountdownTimerWidget(
                    remainingSeconds: provider.remainingSeconds,
                  ),
                  const SizedBox(width: 8),

                  // Exam Title
                  Expanded(
                    child: Text(
                      currentExam?.title ?? 'TOEIC Reading',
                      style: AppTextStyles.appBarTitle.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                // Question Palette Sheet Launcher
                IconButton(
                  tooltip: 'Danh sách câu hỏi',
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.textNavy,
                    size: 20,
                  ),
                  onPressed: () => _openQuestionPalette(context),
                ),

                // Nút "Nộp bài" màu đỏ góc trên bên phải thanh Header (App Bar)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () => _showEarlySubmitDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.badgeRed,
                      foregroundColor: AppColors.textWhite,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 14, color: AppColors.textWhite),
                        SizedBox(width: 4),
                        Text(
                          'Nộp bài',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Close button
                IconButton(
                  tooltip: 'Thoát',
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textDark,
                    size: 22,
                  ),
                  onPressed: () => _confirmQuit(context),
                ),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(26),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Column(
                    children: [
                      // Progress info: "Part 5", "1/100"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentQuestion.partCategory,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textNavy,
                            ),
                          ),
                          Text(
                            '${currentIndex + 1}/100',
                            style: AppTextStyles.progressText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Animated Progress Bar (Figma EL-a31e9bbb) based on 100 questions
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: LinearProgressIndicator(
                          value: (currentIndex + 1) / 100.0,
                          backgroundColor: AppColors.cardDefault,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.brandGreen,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // MAIN CONTENT BODY: Passage + Question + 4 Options
            body: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Reading Passage Card for Part 6 & Part 7 (if available)
                  if (currentQuestion.hasPassage)
                    PassageCard(
                      passageContent: currentQuestion.passageContent!,
                      partName: currentQuestion.partCategory,
                    ),

                  // Question Header & Content from Figma Frame 14:63
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textNavy,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Câu ${currentQuestion.questionNumber > 0 ? currentQuestion.questionNumber : currentIndex + 1}',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentQuestion.content,
                          style: AppTextStyles.questionTitle,
                        ),
                      ],
                    ),
                  ),

                  // 4 Options A, B, C, D (Figma Frames 14:64, 14:72, 14:80, 14:88)
                  ...currentQuestion.options.map((option) {
                    final isSelected = selectedAnswer == option.label;
                    return QuestionOptionTile(
                      option: option,
                      isSelected: isSelected,
                      onTap: () {
                        provider.selectAnswer(currentQuestion.id, option.label);
                      },
                    );
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // BOTTOM NAVIGATION BAR
            // - Shows 'CONTINUE' button on questions 1..N-1 (Màn 2)
            // - Automatically switches to 'FINISH' button on the last question (Màn 3)
            bottomNavigationBar: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.canvasBackground,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Previous Question Button
                  if (!provider.isFirstQuestion) ...[
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.cardDefault,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textNavy,
                          size: 20,
                        ),
                        onPressed: () {
                          provider.previousQuestion();
                          _scrollToTop();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Main Navigation / Submit Button:
                  // CONTINUE (Figma Frame 14:185) vs FINISH (Figma Frame 14:227)
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLast) {
                            // User reached last question: FINISH action (Màn 3)
                            _showSubmitConfirmation(context);
                          } else {
                            // Advance to next question: CONTINUE action (Màn 2)
                            provider.nextQuestion();
                            _scrollToTop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          foregroundColor: AppColors.textWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLast ? 'FINISH' : 'CONTINUE',
                              style: AppTextStyles.actionButton,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isLast
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.arrow_forward_ios_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
