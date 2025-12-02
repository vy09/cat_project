import 'dart:math';
import 'package:flutter/material.dart';

class CaptchaService {
  static final CaptchaService _instance = CaptchaService._internal();
  factory CaptchaService() => _instance;
  CaptchaService._internal();

  String _currentCaptcha = '';
  String _currentMathProblem = '';
  int _mathAnswer = 0;
  int _attempts = 0;
  DateTime _lastAttempt = DateTime.now();
  final List<DateTime> _attemptTimes = [];
  String _sessionToken = '';
  final List<Offset> _mouseMovements = [];

  bool get isValidated => _isValidated;
  bool _isValidated = false;

  // Initialize session with security token
  void initializeSession() {
    _sessionToken = _generateRandomString(32);
    _attempts = 0;
    _attemptTimes.clear();
    _mouseMovements.clear();
  }

  // Generate secure text CAPTCHA
  String generateTextCaptcha() {
    const chars =
        'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789'; // Exclude similar chars like 0,O,1,I
    final random = Random();
    _currentCaptcha = '';

    for (int i = 0; i < 6; i++) {
      _currentCaptcha += chars[random.nextInt(chars.length)];
    }
    return _currentCaptcha;
  }

  // Generate math problem CAPTCHA
  Map<String, dynamic> generateMathCaptcha() {
    final random = Random();
    final operations = ['+', '-', '×'];
    final operation = operations[random.nextInt(operations.length)];

    int num1, num2;

    switch (operation) {
      case '+':
        num1 = random.nextInt(50) + 1;
        num2 = random.nextInt(50) + 1;
        _mathAnswer = num1 + num2;
        break;
      case '-':
        num1 = random.nextInt(50) + 25;
        num2 = random.nextInt(25) + 1;
        _mathAnswer = num1 - num2;
        break;
      case '×':
        num1 = random.nextInt(10) + 1;
        num2 = random.nextInt(10) + 1;
        _mathAnswer = num1 * num2;
        break;
      default:
        num1 = 5;
        num2 = 3;
        _mathAnswer = 8;
    }

    _currentMathProblem = '$num1 $operation $num2 = ?';
    return {'problem': _currentMathProblem, 'answer': _mathAnswer};
  }

  // Validate text CAPTCHA with security checks
  bool validateTextCaptcha(String input) {
    if (!_isValidAttempt()) {
      return false;
    }

    _recordAttempt();
    final isValid = input.toUpperCase() == _currentCaptcha.toUpperCase();

    if (!isValid) {
      _attempts++;
    } else {
      _isValidated = true;
    }

    return isValid;
  }

  // Validate math CAPTCHA
  bool validateMathCaptcha(int input) {
    if (!_isValidAttempt()) {
      return false;
    }

    _recordAttempt();
    final isValid = input == _mathAnswer;

    if (!isValid) {
      _attempts++;
    } else {
      _isValidated = true;
    }

    return isValid;
  }

  // Security checks for bot detection
  bool _isValidAttempt() {
    // Check rate limiting - max 5 attempts
    if (_attempts >= 5) {
      final timeSinceLastAttempt = DateTime.now().difference(_lastAttempt);
      if (timeSinceLastAttempt.inMinutes < 5) {
        return false; // Rate limited - must wait 5 minutes
      } else {
        _attempts = 0; // Reset after cooldown
      }
    }

    // Check for rapid-fire attempts (bot behavior)
    final now = DateTime.now();
    _attemptTimes.removeWhere((time) => now.difference(time).inSeconds > 60);

    if (_attemptTimes.length >= 10) {
      return false; // Too many attempts in short time
    }

    return true;
  }

  void _recordAttempt() {
    _lastAttempt = DateTime.now();
    _attemptTimes.add(_lastAttempt);
  }

  // Mouse movement tracking for human behavior detection
  void recordMouseMovement(Offset position) {
    _mouseMovements.add(position);

    // Keep only recent movements (last 50)
    if (_mouseMovements.length > 50) {
      _mouseMovements.removeAt(0);
    }
  }

  bool _hasHumanLikeMovement() {
    if (_mouseMovements.length < 5) return false;

    // Check for smooth, varied movements (human-like)
    double totalDistance = 0;
    List<double> distances = [];

    for (int i = 1; i < _mouseMovements.length; i++) {
      final distance = (_mouseMovements[i] - _mouseMovements[i - 1]).distance;
      totalDistance += distance;
      distances.add(distance);
    }

    // Calculate movement variance (humans have varied movement patterns)
    if (distances.isEmpty) return false;

    final meanDistance = totalDistance / distances.length;
    double variance = 0;
    for (final distance in distances) {
      variance += (distance - meanDistance) * (distance - meanDistance);
    }
    variance /= distances.length;

    // Human movements have reasonable distance and variance
    return totalDistance > 100 && variance > 10 && _mouseMovements.length > 10;
  }

  // Generate random string for session token
  String _generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  void resetCaptcha() {
    _currentCaptcha = '';
    _currentMathProblem = '';
    _mathAnswer = 0;
    _mouseMovements.clear();
    _isValidated = false;
  }

  void setCaptchaValidation(bool isValid, String captchaText) {
    _isValidated = isValid;
    _currentCaptcha = captchaText;
  }

  bool validateCaptcha(String userInput) {
    return validateTextCaptcha(userInput);
  }

  // Get security status for debugging/monitoring
  Map<String, dynamic> getSecurityStatus() {
    return {
      'attempts': _attempts,
      'isRateLimited': _attempts >= 5,
      'hasHumanMovement': _hasHumanLikeMovement(),
      'sessionToken': _sessionToken,
      'mouseMovements': _mouseMovements.length,
    };
  }
}
