import 'package:cat_project/core/services/exam_service.dart';

void main() async {
  print('🎯 Cat Project - Exam Questions Demo');
  print('=' * 50);

  try {
    final examService = ExamService();
    final questions = await examService.loadExamQuestions();

    print('📊 Total Questions: ${questions.length}');
    print('=' * 50);

    // Display first 3 questions as sample
    for (int i = 0; i < 3 && i < questions.length; i++) {
      final question = questions[i];
      print('\n🔹 Question ${question.questionNumber}');
      print('Question: ${_cleanText(question.soal)}');
      print('\nOptions:');
      print('A. ${_cleanText(question.jawabA)}');
      print('B. ${_cleanText(question.jawabB)}');
      print('C. ${_cleanText(question.jawabC)}');
      print('D. ${_cleanText(question.jawabD)}');
      print('-' * 40);
    }

    print('\n✅ All questions loaded successfully!');
    print('🎓 Ready for exam implementation');
  } catch (e) {
    print('❌ Error loading questions: $e');
  }
}

String _cleanText(String text) {
  return text
      .replaceAll('<br>', '\n')
      .replaceAll('<br/>', '\n')
      .replaceAll('<br />', '\n')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&nbsp;', ' ')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll(RegExp(r'\r\n|\r'), '\n')
      .trim();
}
