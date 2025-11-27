import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const LoadingIndicatorWidget({
    super.key,
    this.size = 40,
    this.strokeWidth = 3,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
