import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/exam_provider.dart';
import '../services/api_service.dart';
import '../widgets/exam_card.dart';
import 'exam_taking_screen.dart';
import 'exam_history_screen.dart';

/// Màn 1 trên Figma - Mục 5 Báo cáo: ExamListScreen
/// - Tiêu đề: "Danh sách đề thi TOEIC"
/// - Gọi API GetAllExams, render các Card đề thi (TOEIC Reading Test 4, 5, 6) kèm thông tin 75 phút | 100 câu
/// - Nút bấm 'Vào thi' / 'Lịch sử làm bài'
class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().loadExams();
    });
  }

  void _startExam(int examId) async {
    final provider = context.read<ExamProvider>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.brandGreen),
      ),
    );

    final success = await provider.startExam(examId);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // dismiss loader
      if (success) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ExamTakingScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.takingExamError ?? 'Không thể tải đề thi. Vui lòng thử lại!',
            ),
            backgroundColor: AppColors.badgeRed,
          ),
        );
      }
    }
  }

  void _showApiConfigDialog() {
    final apiService = ApiService();
    final controller = TextEditingController(text: apiService.baseUrl);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.settings, color: AppColors.textNavy),
            SizedBox(width: 8),
            Text(
              'Cấu hình Backend API',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textNavy,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'URL Backend API ABP:',
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.cardDefault,
                hintText: 'https://localhost:44311/api/services/app/Exam',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('localhost:44311', style: TextStyle(fontSize: 11)),
                  onPressed: () => controller.text =
                      'https://localhost:44311/api/services/app/Exam',
                ),
                ActionChip(
                  label: const Text('10.0.2.2:44311', style: TextStyle(fontSize: 11)),
                  onPressed: () => controller.text =
                      'https://10.0.2.2:44311/api/services/app/Exam',
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              apiService.setBaseUrl(controller.text);
              Navigator.pop(ctx);
              context.read<ExamProvider>().loadExams();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã cập nhật URL API Backend!'),
                  backgroundColor: AppColors.brandGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandGreen,
              foregroundColor: AppColors.textWhite,
            ),
            child: const Text('Lưu & Tải lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasBackground,
      appBar: AppBar(
        backgroundColor: AppColors.canvasBackground,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Danh sách đề thi TOEIC',
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          IconButton(
            tooltip: 'Cài đặt kết nối API',
            icon: const Icon(Icons.tune_rounded, color: AppColors.textNavy),
            onPressed: _showApiConfigDialog,
          ),
        ],
      ),
      body: Consumer<ExamProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingExams) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandGreen),
            );
          }

          final exams = provider.exams;

          return RefreshIndicator(
            color: AppColors.brandGreen,
            onRefresh: () => provider.loadExams(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner / Subtitle from Figma Frame 102:20
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chọn đề thi để bắt đầu làm bài!',
                        style: AppTextStyles.headingLarge,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Các bài thi TOEIC Reading chuẩn format 75 phút | 100 câu',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textNavy,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Exam Cards List
                Expanded(
                  child: exams.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                size: 56,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Không tìm thấy đề thi',
                                style: AppTextStyles.cardTitle,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => provider.loadExams(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.brandGreen,
                                ),
                                child: const Text(
                                  'Tải lại',
                                  style: TextStyle(color: AppColors.textWhite),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: exams.length,
                          itemBuilder: (context, index) {
                            final exam = exams[index];
                            final isSelected =
                                provider.selectedExamId == exam.id;

                            return ExamCard(
                              exam: exam,
                              isSelected: isSelected,
                              onSelect: () => provider.selectExam(exam.id),
                              onStart: () => _startExam(exam.id),
                            );
                          },
                        ),
                ),

                // Bottom Action Buttons from Figma Frame 102:53
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  decoration: BoxDecoration(
                    color: AppColors.canvasBackground,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "Vào thi đề đã chọn" button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            final selectedId = provider.selectedExamId ??
                                (exams.isNotEmpty ? exams.first.id : 1);
                            _startExam(selectedId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandGreen,
                            foregroundColor: AppColors.textWhite,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow_rounded, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'Vào thi ngay',
                                style: AppTextStyles.actionButton,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // "Lịch sử làm bài" button from Figma Frame 102:55
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ExamHistoryScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textNavy,
                            side: const BorderSide(
                              color: AppColors.textNavy,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Lịch sử làm bài',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
