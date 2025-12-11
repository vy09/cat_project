class ApiConstants {
  static const String loginEndpoint = '/auth/login';
  static const String examsEndpoint = '/exams';
  static const String questionsEndpoint = '/questions';
  static const String submitAnswerEndpoint = '/answers';
  
  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}