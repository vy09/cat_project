import 'package:flutter/material.dart';
import 'package:cat_project/Widgets/Exam/exam_header_widget.dart';
import 'package:cat_project/Widgets/Exam/exam_question_widget.dart';
import 'package:cat_project/Widgets/Exam/exam_navigation_widget.dart';

class ExamPage extends StatefulWidget {
  final String examTitle;
  final String examSubtitle;

  const ExamPage({
    super.key,
    required this.examTitle,
    required this.examSubtitle,
  });

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  final Map<int, String> _answers = {};

  // Sample questions - should come from backend
  final List<Map<String, dynamic>> _questions = [
    {
      'number': 1,
      'text':
          'Seorang radiografer melakukan pemeriksaan radiografi abdomen. Ketika berkas primer sinar-X berinteraksi dengan jaringan tubuh, terjadi beberapa proses selama attenuasi berkas sinar-X. Citra radiografi abdomen menunjukkan densitas rendah.\n\nApakah proses yang terjadi selama attenuasi sinar-X pada citra radiografi tersebut?',
      'options': [
        'A. Absorsi foton-foton datang sinar-X',
        'B. Refraksi foton-foton datang sinar-X',
        'C. Refleksi foton-foton datang sinar-X',
        'D. Scatter foton-foton datang sinar-X',
        'E. Transmisi foton-foton datang sinar-X',
      ],
    },
  ];

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _answers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = _answers[_currentQuestionIndex];
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _answers[_currentQuestionIndex];
      });
    }
  }

  void _saveAndContinue() {
    if (_selectedAnswer != null) {
      _answers[_currentQuestionIndex] = _selectedAnswer!;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jawaban disimpan'),
          duration: Duration(seconds: 1),
        ),
      );
      _nextQuestion();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih jawaban terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _skip() {
    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            ExamHeaderWidget(
              examTitle: widget.examTitle,
              examSubtitle: widget.examSubtitle,
              remainingTime: const Duration(hours: 1, minutes: 59, seconds: 59),
              onMenuPressed: () {
                // Show menu options
              },
            ),

            // Question Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ExamQuestionWidget(
                  questionNumber: currentQuestion['number'],
                  questionText: currentQuestion['text'],
                  options: List<String>.from(currentQuestion['options']),
                  selectedAnswer: _selectedAnswer,
                  onAnswerSelected: _selectAnswer,
                ),
              ),
            ),

            // Navigation Buttons
            ExamNavigationWidget(
              onSaveAndContinue: _saveAndContinue,
              onSkip: _skip,
              canGoBack: _currentQuestionIndex > 0,
              onGoBack: _previousQuestion,
            ),
          ],
        ),
      ),
    );
  }
}
