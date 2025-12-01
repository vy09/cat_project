import 'package:flutter/material.dart';
import 'package:cat_project/modules/exam/widgets/exam_header_widget.dart';
import 'package:cat_project/modules/exam/widgets/exam_question_widget.dart';
import 'package:cat_project/modules/exam/widgets/exam_navigation_widget.dart';
import 'package:cat_project/modules/exam/widgets/exam_navigation_drawer.dart';
import 'package:cat_project/data/models/answer_model.dart';

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

  // Sample questions - should come from backend
  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = List.generate(
      30,
      (index) => {
        'number': index + 1,
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
    );
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

  void _goToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _selectedAnswer = _answers[_currentQuestionIndex]?.answer;
    });
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
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      endDrawer: ExamNavigationDrawer(
        totalQuestions: _questions.length,
        currentQuestionIndex: _currentQuestionIndex,
        answers: _answers,
        doubtfulQuestions: _doubtfulQuestions,
        onQuestionSelected: _goToQuestion,
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
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
                  onToggleDoubtful: _toggleDoubtful,
                  isDoubtful: _doubtfulQuestions.contains(
                    _currentQuestionIndex,
                  ),
                  canGoBack: _currentQuestionIndex > 0,
                  onGoBack: _previousQuestion,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
