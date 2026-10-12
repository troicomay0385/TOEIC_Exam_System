import '../models/exam_result_model.dart';

/// Service to keep track of completed exams and test history in session
class ExamHistoryService {
  static final ExamHistoryService _instance = ExamHistoryService._internal();
  factory ExamHistoryService() => _instance;
  ExamHistoryService._internal();

  final List<ExamResultModel> _history = [];

  List<ExamResultModel> get history => List.unmodifiable(_history);

  void addResult(ExamResultModel result) {
    _history.insert(0, result);
  }

  void clearHistory() {
    _history.clear();
  }
}
