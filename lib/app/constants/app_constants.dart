class AppConstants {
  // App Information
  static const String appName = 'COMPUTER ASSISTED TEST';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  static const String examDataKey = 'exam_data';

  // Exam Configuration
  static const int defaultExamDuration = 120; // minutes
  static const int questionsPerPage = 1;
  static const int totalQuestions = 30;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 1000);

  // Image Assets
  static const String logoPath = 'assets/images/logo/logo_bapeten.png';

  // Error Messages
  static const String networkError = 'Koneksi internet bermasalah';
  static const String serverError = 'Terjadi kesalahan pada server';
  static const String unknownError = 'Terjadi kesalahan yang tidak diketahui';
}
