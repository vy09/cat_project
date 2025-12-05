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
  final TextEditingController _textController = TextEditingController();

  String _currentCaptcha = '';
  bool _isValid = false;
  bool _initialized = false;
  int _failedAttempts = 0;

  // Characters for captcha (excluding similar looking ones like 0/O, 1/I/l)
  static const String _captchaChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  @override
  void initState() {
    super.initState();
    _generateNewCaptcha();
    _textController.addListener(_validateInput);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_initialized) {
        _initialized = true;
        widget.onValidationChanged(_isValid);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Generate random alphanumeric captcha
  String _generateRandomCaptcha({int length = 6}) {
    final random = Random();
    return List.generate(
      length,
      (_) => _captchaChars[random.nextInt(_captchaChars.length)],
    ).join();
  }

  void _generateNewCaptcha() {
    setState(() {
      _currentCaptcha = _generateRandomCaptcha();
      _textController.clear();
      _isValid = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onValidationChanged(_isValid);
      }
    });
  }

  void _validateInput() {
    final input = _textController.text.toUpperCase();
    final newIsValid = input == _currentCaptcha;

    if (_isValid != newIsValid) {
      setState(() {
        _isValid = newIsValid;
      });

      if (!newIsValid &&
          _textController.text.length >= _currentCaptcha.length) {
        _failedAttempts++;
        if (_failedAttempts >= 3) {
          _showSecurityWarning();
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onValidationChanged(newIsValid);
        }
      });
    }
  }

  void _showSecurityWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Terlalu banyak percobaan gagal. Silakan refresh CAPTCHA.',
        ),
        backgroundColor: Colors.orange,
      ),
    );
    _refreshCaptcha();
  }

  void _refreshCaptcha() {
    _generateNewCaptcha();
    _failedAttempts = 0;

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
        Row(
          children: [
            const Icon(Icons.security, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            const Text(
              'Verifikasi Captcha',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: _refreshCaptcha,
              icon: const Icon(Icons.refresh, size: 18),
              tooltip: 'Refresh CAPTCHA',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildCaptchaDisplay(),
        const SizedBox(height: 12),
        _buildInputField(),
        if (_isValid)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 14),
                SizedBox(width: 4),
                Text(
                  'Verifikasi berhasil',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCaptchaDisplay() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade100,
            Colors.grey.shade200,
            Colors.grey.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CustomPaint(
        painter: _CaptchaNoisePainter(),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildCaptchaCharacters(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCaptchaCharacters() {
    final random = Random(_currentCaptcha.hashCode);
    final colors = [
      Colors.blue.shade700,
      Colors.red.shade700,
      Colors.green.shade700,
      Colors.purple.shade700,
      Colors.orange.shade700,
      Colors.teal.shade700,
    ];

    return _currentCaptcha.split('').asMap().entries.map((entry) {
      final index = entry.key;
      final char = entry.value;

      // Random rotation between -15 and 15 degrees
      final rotation = (random.nextDouble() - 0.5) * 0.5;
      // Random vertical offset
      final yOffset = (random.nextDouble() - 0.5) * 8;
      // Random color
      final color = colors[random.nextInt(colors.length)];
      // Random font size
      final fontSize = 22.0 + random.nextDouble() * 6;

      return Transform(
        transform: Matrix4.identity()
          ..translate(0.0, yOffset)
          ..rotateZ(rotation),
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            char,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: index % 2 == 0 ? 'Courier' : null,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  color: Colors.black26,
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildInputField() {
    return TextFormField(
      controller: _textController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      maxLength: 6,
      style: const TextStyle(
        letterSpacing: 8,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Masukkan kode',
        hintStyle: TextStyle(
          letterSpacing: 1,
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
        counterText: '',
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _isValid ? Colors.green : Colors.blue,
            width: 2,
          ),
        ),
        suffixIcon: _textController.text.isNotEmpty
            ? Icon(
                _isValid ? Icons.check_circle : Icons.error_outline,
                color: _isValid ? Colors.green : Colors.red.shade300,
                size: 20,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Captcha tidak boleh kosong';
        }
        if (!_isValid) {
          return 'Captcha tidak valid';
        }
        return null;
      },
    );
  }
}

// Custom painter for noise/interference lines
class _CaptchaNoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(DateTime.now().millisecond);
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw random interference lines
    for (int i = 0; i < 6; i++) {
      paint.color = Colors.grey.withOpacity(0.3 + random.nextDouble() * 0.2);
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

    // Draw curved lines
    for (int i = 0; i < 3; i++) {
      paint.color = Colors.grey.withOpacity(0.2);
      final path = Path();
      path.moveTo(0, random.nextDouble() * size.height);
      path.quadraticBezierTo(
        size.width * 0.5,
        random.nextDouble() * size.height,
        size.width,
        random.nextDouble() * size.height,
      );
      canvas.drawPath(path, paint);
    }

    // Draw random dots
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 30; i++) {
      paint.color = Colors.grey.withOpacity(0.3 + random.nextDouble() * 0.2);
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * 1.5 + 0.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
