import 'package:flutter/material.dart';
import 'package:cat_project/Services/dashboard_service.dart';
import 'package:cat_project/Models/exam_model.dart';
import 'package:cat_project/Widgets/Dashboard/exam_count_card.dart';
import 'package:cat_project/Widgets/Dashboard/exam_card.dart';
import 'package:cat_project/Widgets/Dashboard/profile_menu_widget.dart';
import 'package:cat_project/Page/LoginPage/Login_Screen.dart';
import 'package:cat_project/Widgets/Exam/exam_commitment_dialog.dart';
import 'package:cat_project/Page/Exam/exam_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  late List<ExamModel> _exams;

  @override
  void initState() {
    super.initState();
    _exams = _dashboardService.getAvailableExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B7FED),
        elevation: 0,
        title: const Text(
          'COMPUTER ASSISTED TEST',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ProfileMenuWidget(
              userName: 'Fauzan',
              onLogout: _handleLogout,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Penyelenggaraan Section
              const Text(
                'Penyelenggaraan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Ujian Card
              ExamCountCard(examCount: _exams.length),
              const SizedBox(height: 24),

              // Registration Info
              const Text(
                'Anda terdaftar untuk mengikuti ujian online :',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7FED),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Exam List
              ..._exams
                  .map(
                    (exam) => ExamCard(
                      exam: exam,
                      onStartExam: () => _startExam(exam),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _startExam(ExamModel exam) {
    // Show commitment dialog before starting exam
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ExamCommitmentDialog(
          onAccept: () {
            // Navigate to exam screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExamPage(
                  examTitle: 'UJIAN - PILIHAN GANDA',
                  examSubtitle: exam.title,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleLogout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Keluar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate back to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
