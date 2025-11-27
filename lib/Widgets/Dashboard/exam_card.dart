import 'package:flutter/material.dart';
import 'package:cat_project/Models/exam_model.dart';
import 'package:cat_project/Services/dashboard_service.dart';

class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final VoidCallback onStartExam;

  const ExamCard({super.key, required this.exam, required this.onStartExam});

  @override
  Widget build(BuildContext context) {
    final dashboardService = DashboardService();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            exam.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exam.description,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),

          // Registration Date
          Text(
            'Tanggal Penyelenggaraan : ${dashboardService.formatDateTime(exam.registrationDate)}',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),

          // Exam Schedule
          const Text(
            'Rentang Ujian',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mulai  : ${dashboardService.formatDateTime(exam.startDate)}',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 2),
          Text(
            'Selesai : ${dashboardService.formatDateTime(exam.endDate)}',
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),

          // Start Exam Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: dashboardService.canStartExam(exam)
                  ? onStartExam
                  : null,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6B7FED), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'MULAI UJIAN',
                style: TextStyle(
                  color: Color(0xFF6B7FED),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
