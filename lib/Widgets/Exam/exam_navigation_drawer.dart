import 'package:flutter/material.dart';

class ExamNavigationDrawer extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestionIndex;
  final Map<int, String> answers;
  final Function(int) onQuestionSelected;

  const ExamNavigationDrawer({
    super.key,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.answers,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFF6B7FED)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'COMPUTER ASSISTED TEST',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Exam title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF5A6FDB),
              child: const Text(
                'UJIAN - PILIHAN GANDA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Question grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: totalQuestions,
                  itemBuilder: (context, index) {
                    final questionNumber = index + 1;
                    final isCurrentQuestion = index == currentQuestionIndex;
                    final isAnswered = answers.containsKey(index);

                    return _buildQuestionButton(
                      questionNumber: questionNumber,
                      isCurrentQuestion: isCurrentQuestion,
                      isAnswered: isAnswered,
                      onTap: () {
                        onQuestionSelected(index);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionButton({
    required int questionNumber,
    required bool isCurrentQuestion,
    required bool isAnswered,
    required VoidCallback onTap,
  }) {
    Color backgroundColor;
    Color textColor;

    if (isCurrentQuestion) {
      backgroundColor = const Color(0xFFFFC107); // Yellow for current
      textColor = Colors.black87;
    } else if (isAnswered) {
      backgroundColor = const Color(0xFF4CAF50); // Green for answered
      textColor = Colors.white;
    } else {
      backgroundColor = const Color(0xFFE3E7FF); // Light blue for unanswered
      textColor = const Color(0xFF6B7FED);
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            questionNumber.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
