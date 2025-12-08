import 'package:flutter/material.dart';
import 'package:cat_project/modules/exam/widgets/exam_header_widget.dart';
import 'package:cat_project/modules/exam/widgets/exam_question_widget.dart';
import 'package:cat_project/modules/exam/widgets/exam_navigation_widget.dart';
import 'package:cat_project/modules/exam/widgets/exam_navigation_drawer.dart';
import 'package:cat_project/data/models/answer_model.dart';
import 'package:cat_project/data/models/question_model.dart';
import 'package:cat_project/core/services/exam_service.dart';

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
  final Map<int, AnswerModel> _answers = {};
  final Set<int> _doubtfulQuestions = {};

  List<QuestionModel> _questions = [];
  bool _isLoading = true;
  String? _error;
  final ExamService _examService = ExamService();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final questions = await _examService.loadExamQuestions();

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _answers[_currentQuestionIndex] = AnswerModel(
        questionId: _currentQuestionIndex.toString(),
        answer: answer,
        isDoubtful: _doubtfulQuestions.contains(_currentQuestionIndex),
        answeredAt: DateTime.now(),
      );
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = _answers[_currentQuestionIndex]?.answer;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _answers[_currentQuestionIndex]?.answer;
      });
    }
  }

  void _goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      setState(() {
        _currentQuestionIndex = index;
        _selectedAnswer = _answers[_currentQuestionIndex]?.answer;
      });
    }
  }

  void _saveAndContinue() {
    if (_selectedAnswer != null) {
      _answers[_currentQuestionIndex] = AnswerModel(
        questionId: _currentQuestionIndex.toString(),
        answer: _selectedAnswer!,
        isDoubtful: _doubtfulQuestions.contains(_currentQuestionIndex),
        answeredAt: DateTime.now(),
      );
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

  void _finishExam() {
    // Show confirmation dialog before finishing exam
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selesaikan Ujian?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Apakah Anda yakin ingin menyelesaikan ujian?'),
              const SizedBox(height: 12),
              Text(
                'Total soal: ${_questions.length}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Soal terjawab: ${_answers.length}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Soal ragu-ragu: ${_doubtfulQuestions.length}',
                style: const TextStyle(fontSize: 14, color: Colors.orange),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitExam();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
              ),
              child: const Text(
                'Ya, Selesaikan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitExam() {
    // Handle exam submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ujian berhasil diselesaikan!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to dashboard or results page
    Navigator.of(context).pop();
  }

  void _toggleDoubtful() {
    setState(() {
      if (_doubtfulQuestions.contains(_currentQuestionIndex)) {
        _doubtfulQuestions.remove(_currentQuestionIndex);
      } else {
        _doubtfulQuestions.add(_currentQuestionIndex);
      }

      // Update existing answer if any
      if (_answers[_currentQuestionIndex] != null) {
        _answers[_currentQuestionIndex] = _answers[_currentQuestionIndex]!
            .copyWith(
              isDoubtful: _doubtfulQuestions.contains(_currentQuestionIndex),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      endDrawer: _questions.isNotEmpty
          ? ExamNavigationDrawer(
              totalQuestions: _questions.length,
              currentQuestionIndex: _currentQuestionIndex,
              answers: _answers,
              doubtfulQuestions: _doubtfulQuestions,
              onQuestionSelected: _goToQuestion,
            )
          : null,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Memuat soal ujian...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat soal ujian',
                      style: TextStyle(fontSize: 18, color: Colors.red[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadQuestions,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            : _questions.isEmpty
            ? const Center(
                child: Text(
                  'Tidak ada soal yang tersedia',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : Builder(
                builder: (BuildContext context) {
                  final currentQuestion = _questions[_currentQuestionIndex];

                  return Column(
                    children: [
                      // Header
                      ExamHeaderWidget(
                        examTitle: widget.examTitle,
                        examSubtitle: widget.examSubtitle,
                        remainingTime: const Duration(
                          hours: 1,
                          minutes: 59,
                          seconds: 59,
                        ),
                        onMenuPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),

                      // Question Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: ExamQuestionWidget(
                            questionNumber: currentQuestion.questionNumber,
                            questionText: currentQuestion.soal,
                            options: currentQuestion.options,
                            selectedAnswer: _selectedAnswer,
                            onAnswerSelected: _selectAnswer,
                          ),
                        ),
                      ),

                      // Navigation Buttons
                      ExamNavigationWidget(
                        onSaveAndContinue: _saveAndContinue,
                        onSkip: _skip,
                        onToggleDoubtful: _toggleDoubtful,
                        onFinishExam: _finishExam,
                        isDoubtful: _doubtfulQuestions.contains(
                          _currentQuestionIndex,
                        ),
                        canGoBack: _currentQuestionIndex > 0,
                        onGoBack: _previousQuestion,
                        isLastQuestion:
                            _currentQuestionIndex == _questions.length - 1,
                        currentQuestion: _currentQuestionIndex + 1,
                        totalQuestions: _questions.length,
                        onGoToQuestion: _goToQuestion,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
