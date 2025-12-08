import 'package:flutter/material.dart';

class ExamNavigationWidget extends StatelessWidget {
  final VoidCallback onSaveAndContinue;
  final VoidCallback onSkip;
  final VoidCallback onToggleDoubtful;
  final VoidCallback? onFinishExam;
  final Function(int)? onGoToQuestion;
  final bool isDoubtful;
  final bool canGoBack;
  final bool isLastQuestion;
  final VoidCallback? onGoBack;
  final int currentQuestion;
  final int totalQuestions;

  const ExamNavigationWidget({
    super.key,
    required this.onSaveAndContinue,
    required this.onSkip,
    required this.onToggleDoubtful,
    required this.isDoubtful,
    required this.currentQuestion,
    required this.totalQuestions,
    this.canGoBack = false,
    this.onGoBack,
    this.isLastQuestion = false,
    this.onFinishExam,
    this.onGoToQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Question number boxes - positioned at top
          _buildQuestionNumberBoxes(),
          const SizedBox(height: 12),
          // Buttons row
          Row(
            children: [
              // Save and Continue button (or Finish if last question)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isLastQuestion ? onFinishExam : onSaveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastQuestion
                        ? const Color(0xFFFF5722) // Orange for finish
                        : const Color(0xFF4CAF50), // Green for save
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLastQuestion ? 'Selesai' : 'Simpan dan Lanjutkan',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Ragu button
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: onToggleDoubtful,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDoubtful
                        ? const Color(0xFFFFC107)
                        : Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isDoubtful ? 'Ragu ✓' : 'Ragu',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDoubtful ? Colors.black87 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNumberBoxes() {
    // Show 5 question numbers centered on current question
    // Example: if current is 5, show [3] [4] [5] [6] [7]
    List<int> numbers = [];

    // Calculate range: 2 before and 2 after current question
    for (int i = -2; i <= 2; i++) {
      int num = currentQuestion + i;
      numbers.add(num);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: numbers.asMap().entries.map((entry) {
        final index = entry.key;
        final num = entry.value;
        final isVisible = num >= 1 && num <= totalQuestions;
        final isCurrent = num == currentQuestion;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNumberBox(
              number: num,
              isVisible: isVisible,
              isCurrent: isCurrent,
            ),
            if (index < numbers.length - 1) const SizedBox(width: 4),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildNumberBox({
    required int number,
    required bool isVisible,
    required bool isCurrent,
  }) {
    if (!isVisible) {
      return const SizedBox(width: 32, height: 32);
    }

    return GestureDetector(
      onTap: isCurrent ? null : () => onGoToQuestion?.call(number - 1),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCurrent ? const Color(0xFF6B7FED) : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isCurrent ? const Color(0xFF6B7FED) : Colors.grey[400]!,
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isCurrent ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
