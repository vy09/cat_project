import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'api_client.dart';
import 'package:cat_project/modules/dashboard/dashboard_screen.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Handle user login with UI navigation
  Future<void> login(
    BuildContext context,
    String email,
    String password,
    bool rememberMe,
  ) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );

    try {
      // Call API login
      final result = await loginApi(username: email, password: password);

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (result.success) {
        // Navigate to dashboard on success
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// API-based login (without UI)
  Future<AuthResult> loginApi({
    required String username,
    required String password,
  }) async {
    try {
      // Send plain password - backend will handle hashing and verification
      final response = await _apiClient.post('/auth/login', {
        'username': username,
        'password': password,
      }, includeAuth: false);

      if (response.success) {
        // Save token securely
        final token = response.data['token'] ?? '';
        if (token.isNotEmpty) {
          await _storage.write(key: 'auth_token', value: token);
        }

        // Save user data
        final userData = response.data['user'];
        if (userData != null) {
          await _storage.write(key: 'user_data', value: jsonEncode(userData));
        }

        return AuthResult(
          success: true,
          message: response.message,
          user: userData,
        );
      } else {
        return AuthResult(success: false, message: response.message);
      }
    } catch (e) {
      return AuthResult(success: false, message: 'Login failed: $e');
    }
  }

  /// Handle user logout
  Future<void> logout(BuildContext context) async {
    try {
      // Call logout API endpoint
      await _apiClient.post('/auth/logout', {});
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear all stored data
      await _storage.deleteAll();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout berhasil'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }

  /// Get current auth token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Get current user data
  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: 'user_data');
    if (userData != null && userData.isNotEmpty) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  /// Refresh auth token
  Future<bool> refreshToken() async {
    try {
      final response = await _apiClient.post('/auth/refresh', {});

      if (response.success) {
        final newToken = response.data['token'];
        if (newToken != null) {
          await _storage.write(key: 'auth_token', value: newToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Validate token expiration (if you have JWT)
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      // Simple validation - you can implement JWT decode if needed
      // For now, just check if token exists
      return token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

/// Auth Result Model
class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? user;

  AuthResult({required this.success, required this.message, this.user});

  @override
  String toString() {
    return 'AuthResult(success: $success, message: $message)';
  }
}
