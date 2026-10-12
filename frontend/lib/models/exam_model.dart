import 'question_model.dart';

/// Exam DTO matching backend ExamDto
class ExamModel {
  final int id;
  final String title;
  final int duration; // in minutes (default 75)
  final int totalQuestions;
  final List<QuestionModel> questions;

  ExamModel({
    required this.id,
    required this.title,
    this.duration = 75,
    this.totalQuestions = 100,
    this.questions = const [],
  });

  /// Real number of questions: prioritized from questions list if available
  int get questionCount => questions.isNotEmpty ? questions.length : totalQuestions;

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    var rawQuestions = json['questions'] ?? json['Questions'] ?? [];
    List<QuestionModel> parsedQuestions = [];
    if (rawQuestions is List) {
      parsedQuestions = rawQuestions
          .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final rawTotal = (json['totalQuestions'] ??
            json['TotalQuestions'] ??
            parsedQuestions.length) as int;

    return ExamModel(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      title: (json['title'] ?? json['Title'] ?? 'Đề thi TOEIC').toString(),
      duration: (json['duration'] ?? json['Duration'] ?? 75) as int,
      totalQuestions: parsedQuestions.isNotEmpty ? parsedQuestions.length : rawTotal,
      questions: parsedQuestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  ExamModel copyWith({
    int? id,
    String? title,
    int? duration,
    int? totalQuestions,
    List<QuestionModel>? questions,
  }) {
    final updatedQuestions = questions ?? this.questions;
    return ExamModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      totalQuestions: totalQuestions ??
          (updatedQuestions.isNotEmpty
              ? updatedQuestions.length
              : this.totalQuestions),
      questions: updatedQuestions,
    );
  }
}
