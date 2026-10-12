/// Option DTO matching backend OptionDto (Label: 'A'|'B'|'C'|'D', Content: string)
class OptionModel {
  final String label;
  final String content;

  OptionModel({
    required this.label,
    required this.content,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      label: (json['label'] ?? json['Label'] ?? '').toString().trim(),
      content: (json['content'] ?? json['Content'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'content': content,
    };
  }

  @override
  String toString() => 'Option($label: $content)';
}
