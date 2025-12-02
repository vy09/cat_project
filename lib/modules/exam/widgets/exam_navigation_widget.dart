import 'package:flutter/material.dart';

class ExamNavigationWidget extends StatelessWidget {
  final VoidCallback onSaveAndContinue;
  final VoidCallback onSkip;
  final VoidCallback onToggleDoubtful;
  final VoidCallback? onFinishExam;
  final bool isDoubtful;
  final bool canGoBack;
  final bool isLastQuestion;
  final VoidCallback? onGoBack;

  const ExamNavigationWidget({
    super.key,
    required this.onSaveAndContinue,
    required this.onSkip,
    required this.onToggleDoubtful,
    required this.isDoubtful,
    this.canGoBack = false,
    this.onGoBack,
    this.isLastQuestion = false,
    this.onFinishExam,
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
      child: Row(
        children: [
          // Save button (or Save and Continue if not last question)
          Expanded(
            child: ElevatedButton(
              onPressed: onSaveAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Ragu button
          Expanded(
            child: ElevatedButton(
              onPressed: onToggleDoubtful,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDoubtful
                    ? const Color(0xFFFFC107)
                    : Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                isDoubtful ? 'Ragu ✓' : 'Ragu',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDoubtful ? Colors.black87 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Conditional button: Finish or Skip
          Expanded(
            child: ElevatedButton(
              onPressed: isLastQuestion ? onFinishExam : onSkip,
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastQuestion
                    ? const Color(0xFFFF5722) // Orange for finish
                    : const Color(0xFF6B7FED), // Blue for skip
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                isLastQuestion ? 'Selesai' : 'Lewati',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
