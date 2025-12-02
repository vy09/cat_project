import 'package:flutter/material.dart';
import 'package:cat_project/core/services/captcha_service.dart';
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
  final _captchaService = CaptchaService();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _mathController = TextEditingController();

  String _captchaType = 'text'; // text or math
  String _currentCaptcha = '';
  Map<String, dynamic> _mathProblem = {};
  bool _isValid = false;
  bool _initialized = false;
  int _failedAttempts = 0;
  @override
  void initState() {
    super.initState();
    _captchaService.initializeSession();
    _generateNewCaptcha();
    _textController.addListener(_validateInput);
    _mathController.addListener(_validateInput);

    // Initialize state after the first frame
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
    _mathController.dispose();
    super.dispose();
  }

  void _generateNewCaptcha() {
    setState(() {
      // Randomly select CAPTCHA type
      final types = ['text', 'math'];
      _captchaType = types[DateTime.now().millisecond % types.length];

      switch (_captchaType) {
        case 'text':
          _currentCaptcha = _captchaService.generateTextCaptcha();
          break;
        case 'math':
          _mathProblem = _captchaService.generateMathCaptcha();
          break;
      }

      _textController.clear();
      _mathController.clear();
      _isValid = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onValidationChanged(_isValid);
      }
    });
  }

  void _validateInput() {
    bool newIsValid = false;

    switch (_captchaType) {
      case 'text':
        if (_textController.text.length >= 6) {
          newIsValid = _captchaService.validateTextCaptcha(
            _textController.text,
          );
        }
        break;
      case 'math':
        final input = int.tryParse(_mathController.text);
        if (input != null) {
          newIsValid = _captchaService.validateMathCaptcha(input);
        }
        break;
    }

    if (_isValid != newIsValid) {
      setState(() {
        _isValid = newIsValid;
      });

      if (!newIsValid &&
          (_textController.text.isNotEmpty ||
              _mathController.text.isNotEmpty)) {
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
    return MouseRegion(
      onHover: (event) {
        _captchaService.recordMouseMovement(event.localPosition);
      },
      child: Column(
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
          const SizedBox(height: 4),
          _buildCaptchaContent(),
          const SizedBox(height: 8),
          _buildInputField(),
          if (_isValid)
            const Padding(
              padding: EdgeInsets.only(top: 4),
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
      ),
    );
  }

  Widget _buildCaptchaContent() {
    switch (_captchaType) {
      case 'text':
        return _buildTextCaptcha();
      case 'math':
        return _buildMathCaptcha();
      default:
        return _buildTextCaptcha();
    }
  }

  Widget _buildTextCaptcha() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: CustomPaint(
          painter: _SecureCaptchaPainter(_currentCaptcha),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                _currentCaptcha,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMathCaptcha() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Center(
        child: Text(
          _mathProblem['problem'] ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    final controller = _captchaType == 'text'
        ? _textController
        : _mathController;
    final hintText = _captchaType == 'text'
        ? 'Masukkan kode captcha'
        : 'Masukkan jawaban';
    final keyboardType = _captchaType == 'text'
        ? TextInputType.text
        : TextInputType.number;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: _captchaType == 'text'
          ? TextCapitalization.characters
          : TextCapitalization.none,
      decoration: InputDecoration(
        hintText: hintText,
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
        suffixIcon: controller.text.isNotEmpty
            ? Icon(
                _isValid ? Icons.check_circle : Icons.error,
                color: _isValid ? Colors.green : Colors.red,
                size: 18,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
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

class _SecureCaptchaPainter extends CustomPainter {
  final String text;

  _SecureCaptchaPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final random = Random();

    // Draw security noise lines
    for (int i = 0; i < 8; i++) {
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

    // Draw security dots
    for (int i = 0; i < 25; i++) {
      paint.color = Colors.grey.withOpacity(0.4);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        0.8,
        paint,
      );
    }

    // Add some curved interference lines
    final path = Path();
    for (int i = 0; i < 3; i++) {
      paint.style = PaintingStyle.stroke;
      paint.color = Colors.grey.withOpacity(0.2);
      path.reset();
      path.moveTo(0, random.nextDouble() * size.height);
      path.quadraticBezierTo(
        size.width / 2,
        random.nextDouble() * size.height,
        size.width,
        random.nextDouble() * size.height,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
