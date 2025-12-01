import 'package:flutter/material.dart';

class ExamNavigationWidget extends StatelessWidget {
  final VoidCallback onSaveAndContinue;
  final VoidCallback onSkip;
  final VoidCallback onToggleDoubtful;
  final bool isDoubtful;
  final bool canGoBack;
  final VoidCallback? onGoBack;

  const ExamNavigationWidget({
    super.key,
    required this.onSaveAndContinue,
    required this.onSkip,
    required this.onToggleDoubtful,
    required this.isDoubtful,
    this.canGoBack = false,
    this.onGoBack,
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
          // First row: Save and Continue + Ragu buttons
          Row(
            children: [
              // Save and Continue button
              Expanded(
                flex: 2,
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
                    'Simpan dan Lanjutkan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDoubtful ? Colors.black87 : Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Second row: Skip button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSkip,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B7FED),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Lewati',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
