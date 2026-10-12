import 'option_model.dart';

/// Question DTO matching backend QuestionDto
class QuestionModel {
  final int id;
  final int questionNumber;
  final String content;
  final String correctAnswer;
  final String? passageContent;
  final List<OptionModel> options;

  QuestionModel({
    required this.id,
    required this.questionNumber,
    required this.content,
    required this.correctAnswer,
    this.passageContent,
    required this.options,
  });

  /// Check if the question is Part 5 (no passage) or Part 6/7 (with reading passage)
  bool get hasPassage =>
      passageContent != null && passageContent!.trim().isNotEmpty;

  bool get isPart5 => !hasPassage;

  /// Returns the part section name according to TOEIC Reading test standard
  String get partCategory {
    if (questionNumber <= 140 && !hasPassage) {
      return 'Part 5: Incomplete Sentences';
    } else if (questionNumber <= 152 || (hasPassage && questionNumber <= 152)) {
      return 'Part 6: Text Completion';
    } else {
      return 'Part 7: Reading Comprehension';
    }
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var rawOptions = json['options'] ?? json['Options'] ?? [];
    List<OptionModel> parsedOptions = [];
    if (rawOptions is List) {
      parsedOptions = rawOptions
          .map((item) => OptionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return QuestionModel(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      questionNumber:
          (json['questionNumber'] ?? json['QuestionNumber'] ?? 0) as int,
      content: (json['content'] ?? json['Content'] ?? '').toString().trim(),
      correctAnswer: (json['correctAnswer'] ?? json['CorrectAnswer'] ?? '')
          .toString()
          .trim()
          .toUpperCase(),
      passageContent: (json['passageContent'] ?? json['PassageContent'])?.toString(),
      options: parsedOptions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionNumber': questionNumber,
      'content': content,
      'correctAnswer': correctAnswer,
      'passageContent': passageContent,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}
