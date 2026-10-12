import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/exam_model.dart';
import '../models/question_model.dart';
import '../models/exam_result_model.dart';
import '../services/api_service.dart';
import '../services/exam_history_service.dart';

/// Central state provider using Provider package
class ExamProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ExamHistoryService _historyService = ExamHistoryService();

  // Screen 1: Exam List State
  List<ExamModel> _exams = [];
  bool _isLoadingExams = false;
  String? _examListError;
  int? _selectedExamId;

  // Screen 2 & 3: Taking Exam State
  ExamModel? _currentExam;
  bool _isLoadingExamDetail = false;
  String? _takingExamError;
  int _currentQuestionIndex = 0;
  final Map<int, String> _userAnswers = {}; // questionId -> 'A' | 'B' | 'C' | 'D'
  int _remainingSeconds = 75 * 60; // 75 minutes in seconds
  Timer? _countdownTimer;
  int _timeSpentSeconds = 0;
  bool _isAutoSubmitted = false;

  // Screen 4: Result State
  ExamResultModel? _latestResult;

  // Getters
  List<ExamModel> get exams => _exams;
  bool get isLoadingExams => _isLoadingExams;
  String? get examListError => _examListError;
  int? get selectedExamId => _selectedExamId;

  ExamModel? get currentExam => _currentExam;
  bool get isLoadingExamDetail => _isLoadingExamDetail;
  String? get takingExamError => _takingExamError;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, String> get userAnswers => _userAnswers;
  int get remainingSeconds => _remainingSeconds;
  bool get isAutoSubmitted => _isAutoSubmitted;
  ExamResultModel? get latestResult => _latestResult;
  List<ExamResultModel> get history => _historyService.history;

  QuestionModel? get currentQuestion {
    if (_currentExam == null || _currentExam!.questions.isEmpty) return null;
    if (_currentQuestionIndex < 0 ||
        _currentQuestionIndex >= _currentExam!.questions.length) {
      return null;
    }
    return _currentExam!.questions[_currentQuestionIndex];
  }

  bool get isFirstQuestion => _currentQuestionIndex == 0;

  bool get isLastQuestion {
    if (_currentExam == null || _currentExam!.questions.isEmpty) return false;
    return _currentQuestionIndex == _currentExam!.questions.length - 1;
  }

  int get totalQuestions => 100;

  int get loadedQuestionsCount => _currentExam?.questions.length ?? 0;

  int get answeredCount => _userAnswers.length;

  double get progressPercentage {
    return (_currentQuestionIndex + 1) / 100.0;
  }

  String get formattedRemainingTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // ==========================================
  // Actions: Exam List Screen (Màn 1)
  // ==========================================

  void selectExam(int examId) {
    _selectedExamId = examId;
    notifyListeners();
  }

  Future<void> loadExams() async {
    _isLoadingExams = true;
    _examListError = null;
    notifyListeners();

    try {
      _exams = await _apiService.getAllExams();
      if (_exams.isNotEmpty && _selectedExamId == null) {
        _selectedExamId = _exams.first.id;
      }
    } catch (e) {
      _examListError = e.toString();
    } finally {
      _isLoadingExams = false;
      notifyListeners();
    }
  }

  // ==========================================
  // Actions: Exam Taking Screen (Màn 2 & 3)
  // ==========================================

  Future<bool> startExam(int examId) async {
    _isLoadingExamDetail = true;
    _takingExamError = null;
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _isAutoSubmitted = false;
    _timeSpentSeconds = 0;
    _stopTimer();
    notifyListeners();

    try {
      _currentExam = await _apiService.getExamDetail(examId);

      // Cập nhật lại đề thi chi tiết vào _exams để đồng bộ số lượng câu hỏi
      final index = _exams.indexWhere((e) => e.id == examId);
      if (index != -1 && _currentExam != null) {
        _exams[index] = _currentExam!;
      }

      final durationMinutes = _currentExam?.duration ?? 75;
      _remainingSeconds = durationMinutes * 60;

      _startTimer();
      _isLoadingExamDetail = false;
      notifyListeners();
      return true;
    } catch (e) {
      _takingExamError = e.toString();
      _isLoadingExamDetail = false;
      notifyListeners();
      return false;
    }
  }

  void _startTimer() {
    _stopTimer();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _timeSpentSeconds++;
        notifyListeners();
      } else {
        // Automatically submit when time expires
        _stopTimer();
        _isAutoSubmitted = true;
        submitExam();
      }
    });
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  /// Select answer option ('A', 'B', 'C', 'D') for current question
  void selectAnswer(int questionId, String optionLabel) {
    _userAnswers[questionId] = optionLabel;
    notifyListeners();
  }

  /// Advance to next question (Màn 2 CONTINUE button)
  void nextQuestion() {
    if (!isLastQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Return to previous question
  void previousQuestion() {
    if (!isFirstQuestion) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// Jump directly to any question by index
  void jumpToQuestion(int index) {
    if (index >= 0 && index < loadedQuestionsCount) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  /// Submit the exam (Màn 3 FINISH button or Auto-submit on time expiry)
  ExamResultModel submitExam() {
    _stopTimer();

    final exam = _currentExam;
    final questions = exam?.questions ?? [];

    final result = ExamResultModel.evaluate(
      examId: exam?.id ?? 0,
      examTitle: exam?.title ?? 'TOEIC Reading Test',
      questions: questions,
      userAnswers: _userAnswers,
      timeSpentSeconds: _timeSpentSeconds,
    );

    _latestResult = result;
    _historyService.addResult(result);
    notifyListeners();

    return result;
  }

  /// Reset current taking session
  void resetTakingExam() {
    _stopTimer();
    _currentExam = null;
    _userAnswers.clear();
    _currentQuestionIndex = 0;
    _isAutoSubmitted = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
