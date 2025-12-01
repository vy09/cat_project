class QuestionModel {
  final int number;
  final String id;
  final String text;
  final List<String> options;

  QuestionModel({
    required this.number,
    required this.id,
    required this.text,
    required this.options,
  });
}
