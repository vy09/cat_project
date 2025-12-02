import 'package:flutter/material.dart';

class ExamQuestionWidget extends StatelessWidget {
  final int questionNumber;
  final String questionText;
  final List<String> options;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  const ExamQuestionWidget({
    super.key,
    required this.questionNumber,
    required this.questionText,
    required this.options,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  /// Clean HTML tags and format text for display
  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('<br />', '\n')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove all HTML tags
        .replaceAll(RegExp(r'\r\n|\r'), '\n') // Normalize line breaks
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number
          Text(
            'Soal No. $questionNumber',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Question text
          Text(
            _cleanHtmlText(questionText),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),
          // Answer options
          ...options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildOptionButton(option),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    final isSelected = selectedAnswer == option;

    return InkWell(
      onTap: () => onAnswerSelected(option),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8EAFF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF6B7FED) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          _cleanHtmlText(option),
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? const Color(0xFF6B7FED) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
