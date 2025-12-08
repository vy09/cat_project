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
      // Show popup notification for no answer selected
      _showWarningPopup(
        title: 'Silakan Pilih Jawaban',
        message:
            'Anda belum memilih jawaban untuk soal ini. Silakan pilih salah satu jawaban terlebih dahulu.',
        icon: Icons.edit_note_rounded,
        iconColor: const Color(0xFF6B7FED),
        showCancelButton: false,
        confirmText: 'OK, Mengerti',
        onConfirm: () {},
      );
    }
  }

  void _skip() {
    _nextQuestion();
  }

  void _finishExam() {
    // Calculate unanswered questions
    final int totalQuestions = _questions.length;
    final int answeredCount = _answers.length;
    final int unansweredCount = totalQuestions - answeredCount;
    final int doubtfulCount = _doubtfulQuestions.length;

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
                'Total soal: $totalQuestions',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Soal terjawab: $answeredCount',
                style: const TextStyle(fontSize: 14, color: Colors.green),
              ),
              if (unansweredCount > 0)
                Text(
                  'Soal belum dijawab: $unansweredCount',
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              if (doubtfulCount > 0)
                Text(
                  'Soal ragu-ragu: $doubtfulCount',
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
    // Calculate results
    final int totalQuestions = _questions.length;
    final int answeredCount = _answers.length;
    final int unansweredCount = totalQuestions - answeredCount;

    // Show success popup notification
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF7B8EF7), Color(0xFF6B7FED)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Checkmark icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Ujian Telah Selesai!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildResultRow('Total Soal', '$totalQuestions'),
                      const SizedBox(height: 8),
                      _buildResultRow(
                        'Terjawab',
                        '$answeredCount',
                        Colors.greenAccent,
                      ),
                      if (unansweredCount > 0) ...[
                        const SizedBox(height: 8),
                        _buildResultRow(
                          'Belum Dijawab',
                          '$unansweredCount',
                          Colors.redAccent,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // Go back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6B7FED),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultRow(String label, String value, [Color? valueColor]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  void _toggleDoubtful() {
    // Check if no answer selected when marking as doubtful
    if (!_doubtfulQuestions.contains(_currentQuestionIndex) &&
        _selectedAnswer == null) {
      // Show warning popup
      _showWarningPopup(
        title: 'Belum Ada Jawaban',
        message:
            'Anda belum memilih jawaban untuk soal ini. Apakah tetap ingin menandai sebagai ragu-ragu?',
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        onConfirm: () {
          setState(() {
            _doubtfulQuestions.add(_currentQuestionIndex);
          });
        },
      );
      return;
    }

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

  void _showWarningPopup({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onConfirm,
    bool showCancelButton = true,
    String confirmText = 'Ya, Lanjutkan',
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  iconColor.withOpacity(0.9),
                  iconColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Message
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Buttons
                if (showCancelButton)
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Confirm button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onConfirm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: iconColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            confirmText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // Single OK button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: iconColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
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
