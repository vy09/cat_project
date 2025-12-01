class AnswerModel {
  final String questionId;
  final String answer;
  final bool isDoubtful; // Menandai apakah jawaban ini ragu-ragu
  final DateTime answeredAt;

  AnswerModel({
    required this.questionId,
    required this.answer,
    this.isDoubtful = false,
    required this.answeredAt,
  });

  AnswerModel copyWith({
    String? questionId,
    String? answer,
    bool? isDoubtful,
    DateTime? answeredAt,
  }) {
    return AnswerModel(
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
      isDoubtful: isDoubtful ?? this.isDoubtful,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}
