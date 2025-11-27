import 'package:flutter/material.dart';
import 'package:cat_project/Services/dashboard_service.dart';
import 'package:cat_project/Models/exam_model.dart';
import 'package:cat_project/Page/Dashboard/Widget/exam_count_card.dart';
import 'package:cat_project/Page/Dashboard/Widget/exam_card.dart';

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
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(Icons.person, color: Color(0xFF6B7FED), size: 20),
            ),
            onPressed: () {
              // Handle profile tap
            },
          ),
          const SizedBox(width: 8),
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
    // TODO: Navigate to exam screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memulai ujian: ${exam.title}'),
        backgroundColor: const Color(0xFF6B7FED),
      ),
    );
  }
}
