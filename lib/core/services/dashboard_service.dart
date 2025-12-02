import 'package:cat_project/data/models/exam_model.dart';

class DashboardService {
  /// Get list of available exams
  List<ExamModel> getAvailableExams() {
    return [
      ExamModel(
        id: '1',
        title:
            'Ujian (baru & ulang) Sertifikasi Kompetensi Personil PB lingkup Mammografi 2025 Tahap-2',
        description: '(Pilihan ganda)',
        registrationDate: DateTime(2025, 11, 24),
        startDate: DateTime(2025, 11, 24, 8, 45),
        endDate: DateTime(2025, 12, 29, 12, 15),
        isOpen: true,
      ),
    ];
  }

  /// Check if user can start exam
  bool canStartExam(ExamModel exam) {
    // Always allow exam for testing purposes
    return exam.isOpen;
  }

  /// Format date time for display
  String formatDateTime(DateTime dateTime) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2,'0');

    return '$day $month $year, $hour.$minute AM';
  }
}
