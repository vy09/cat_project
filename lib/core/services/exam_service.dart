import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cat_project/data/models/question_model.dart';

class ExamService {
  static final ExamService _instance = ExamService._internal();
  factory ExamService() => _instance;
  ExamService._internal();

  List<QuestionModel>? _cachedQuestions;

  /// Load exam questions from JSON file
  Future<List<QuestionModel>> loadExamQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    try {
      // Load JSON from assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/exam_questions.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse questions
      final List<dynamic> questionsList = jsonData['v_cat_rekap_nilai'] ?? [];

      _cachedQuestions = questionsList.map((questionJson) {
        final question = QuestionModel.fromJson(questionJson);
        return question;
      }).toList();

      // Set question numbers
      for (int i = 0; i < _cachedQuestions!.length; i++) {
        _cachedQuestions![i] = _cachedQuestions![i].copyWith(
          questionNumber: i + 1,
        );
      }

      return _cachedQuestions!;
    } catch (e) {
      throw Exception('Failed to load exam questions: $e');
    }
  }

  /// Get a specific question by index
  Future<QuestionModel?> getQuestion(int index) async {
    final questions = await loadExamQuestions();
    if (index >= 0 && index < questions.length) {
      return questions[index];
    }
    return null;
  }

  /// Get total number of questions
  Future<int> getTotalQuestions() async {
    final questions = await loadExamQuestions();
    return questions.length;
  }

  /// Clear cached questions (for testing or refresh)
  void clearCache() {
    _cachedQuestions = null;
  }

  /// Shuffle questions randomly
  Future<List<QuestionModel>> getShuffledQuestions() async {
    final questions = await loadExamQuestions();
    final shuffled = List<QuestionModel>.from(questions);
    shuffled.shuffle();

    // Reassign question numbers after shuffling
    for (int i = 0; i < shuffled.length; i++) {
      shuffled[i] = shuffled[i].copyWith(questionNumber: i + 1);
    }

    return shuffled;
  }

  /// Get questions in a specific range
  Future<List<QuestionModel>> getQuestionsRange(int start, int count) async {
    final questions = await loadExamQuestions();
    final end = (start + count).clamp(0, questions.length);
    return questions.sublist(start, end);
  }

  /// Search questions by keyword in question text
  Future<List<QuestionModel>> searchQuestions(String keyword) async {
    final questions = await loadExamQuestions();
    return questions
        .where(
          (question) =>
              question.soal.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();
  }
}
