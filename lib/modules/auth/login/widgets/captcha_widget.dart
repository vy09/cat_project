import 'package:flutter/material.dart';
import 'dart:math';

class CaptchaWidget extends StatefulWidget {
  final Function(bool) onValidationChanged;
  final VoidCallback onRefresh;

  const CaptchaWidget({
    super.key,
    required this.onValidationChanged,
    required this.onRefresh,
  });

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  final TextEditingController _captchaController = TextEditingController();
  String _captchaText = '';
  bool _isValid = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _generateCaptchaText();
    _captchaController.addListener(_validateCaptcha);

    // Initialize state after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_initialized) {
        _initialized = true;
        widget.onValidationChanged(_isValid);
      }
    });
  }

  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }

  void _generateCaptchaText() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    _captchaText = String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  void _generateCaptcha() {
    _generateCaptchaText();
    _captchaController.clear();
    setState(() {
      _isValid = false;
    });

    // Notify parent after state update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onValidationChanged(_isValid);
      }
    });
  }

  void _validateCaptcha() {
    final isValid = _captchaController.text.toUpperCase() == _captchaText;
    if (_isValid != isValid) {
      setState(() {
        _isValid = isValid;
      });

      // Notify parent after state update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onValidationChanged(isValid);
        }
      });
    }
  }

  void _refreshCaptcha() {
    _generateCaptcha();

    // Notify parent after refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verifikasi Captcha',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Captcha Display
        Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              // Captcha Text with styling
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: CustomPaint(
                    painter: CaptchaPainter(_captchaText),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Text(
                          _captchaText,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Refresh Button
              IconButton(
                onPressed: _refreshCaptcha,
                icon: const Icon(Icons.refresh, color: Colors.blue),
                tooltip: 'Refresh Captcha',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Input Field
        TextFormField(
          controller: _captchaController,
          decoration: InputDecoration(
            hintText: 'Masukkan kode captcha',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid ? Colors.green : Colors.blue,
                width: 2,
              ),
            ),
            suffixIcon: _captchaController.text.isNotEmpty
                ? Icon(
                    _isValid ? Icons.check_circle : Icons.error,
                    color: _isValid ? Colors.green : Colors.red,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Captcha tidak boleh kosong';
            }
            if (!_isValid) {
              return 'Captcha tidak valid';
            }
            return null;
          },
        ),
        if (_isValid)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '✓ Captcha valid',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class CaptchaPainter extends CustomPainter {
  final String text;

  CaptchaPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final random = Random();

    // Draw random lines for noise
    for (int i = 0; i < 3; i++) {
      paint.color = Colors.grey.withOpacity(0.3);
      canvas.drawLine(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        paint,
      );
    }

    // Draw random dots
    for (int i = 0; i < 20; i++) {
      paint.color = Colors.grey.withOpacity(0.4);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
