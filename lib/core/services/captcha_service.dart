class CaptchaService {
  static final CaptchaService _instance = CaptchaService._internal();
  factory CaptchaService() => _instance;
  CaptchaService._internal();

  bool _isValidated = false;
  String _currentCaptcha = '';

  bool get isValidated => _isValidated;

  void setCaptchaValidation(bool isValid, String captchaText) {
    _isValidated = isValid;
    _currentCaptcha = captchaText;
  }

  void resetCaptcha() {
    _isValidated = false;
    _currentCaptcha = '';
  }

  bool validateCaptcha(String userInput) {
    return userInput.toUpperCase() == _currentCaptcha.toUpperCase();
  }
}
