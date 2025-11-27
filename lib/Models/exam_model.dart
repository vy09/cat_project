class ExamModel {
  final String id;
  final String title;
  final String description;
  final DateTime registrationDate;
  final DateTime startDate;
  final DateTime endDate;
  final bool isOpen;

  ExamModel({
    required this.id,
    required this.title,
    required this.description,
    required this.registrationDate,
    required this.startDate,
    required this.endDate,
    required this.isOpen,
  });
}
