import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration Service
/// Reads configuration from .env files using flutter_dotenv
class EnvironmentConfig {
  // Singleton pattern
  static final EnvironmentConfig _instance = EnvironmentConfig._internal();
  factory EnvironmentConfig() => _instance;
  EnvironmentConfig._internal();

  /// Initialize environment configuration
  /// Call this before runApp() in main.dart
  static Future<void> initialize({String? fileName}) async {
    await dotenv.load(fileName: fileName ?? '.env');
  }

  // API Configuration
  String get apiUrl =>
      dotenv.get('API_URL', fallback: 'http://localhost:3000/api');
  String get apiKey => dotenv.get('API_KEY', fallback: '');
  int get apiTimeout =>
      int.tryParse(dotenv.get('API_TIMEOUT', fallback: '30')) ?? 30;

  // Authentication
  String get jwtSecret => dotenv.get('JWT_SECRET', fallback: '');

  // Encryption
  String get encryptionKey => dotenv.get('ENCRYPTION_KEY', fallback: '');

  // App Configuration
  String get appEnv => dotenv.get('APP_ENV', fallback: 'development');
  bool get debugMode =>
      dotenv.get('DEBUG_MODE', fallback: 'false').toLowerCase() == 'true';
  bool get isProduction => appEnv == 'production';
  bool get isDevelopment => appEnv == 'development';

  // Validation
  bool validateConfig() {
    final errors = <String>[];

    if (apiUrl.isEmpty) errors.add('API_URL is required');
    if (apiKey.isEmpty) errors.add('API_KEY is required');
    if (jwtSecret.isEmpty) errors.add('JWT_SECRET is required');
    if (encryptionKey.isEmpty) errors.add('ENCRYPTION_KEY is required');
    if (encryptionKey.length < 32)
      errors.add('ENCRYPTION_KEY must be at least 32 characters');

    if (errors.isNotEmpty) {
      if (debugMode) {
        print('Environment Configuration Errors:');
        for (var error in errors) {
          print('  - $error');
        }
      }
      return false;
    }

    return true;
  }

  // Display configuration (safe - without sensitive data)
  void printConfig() {
    if (!debugMode) return;

    print('=== Environment Configuration ===');
    print('Environment: $appEnv');
    print('API URL: $apiUrl');
    print('API Timeout: ${apiTimeout}s');
    print('Debug Mode: $debugMode');
    print('=================================');
  }
}
