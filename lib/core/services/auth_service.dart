import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:cat_project/modules/dashboard/dashboard_screen.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_URL']!;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Handle user login with UI navigation
  /// [username] can be email or username
  /// [password] user password
  /// [rememberMe] whether to remember login session
  Future<void> login(
    BuildContext context,
    String username,
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
      final result = await loginApi(username: username, password: password);

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
  /// [username] accepts both email and username format
  /// [password] plain password - backend handles hashing
  Future<AuthResult> loginApi({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/generateToken');
      final body = {'username': username, 'password': password};

      // Send plain password - backend will handle hashing and verification
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      // Check if response status is 200 (success)
      if (data['status'] == 200) {
        // Data ada di dalam "response" key
        final responseData = data['response'];

        // Save token securely
        final token = responseData['token'] ?? '';
        if (token.isNotEmpty) {
          await _storage.write(key: 'auth_token', value: token);
        }

        // Save username
        if (responseData['username'] != null) {
          await _storage.write(
            key: 'username',
            value: responseData['username'],
          );
        }

        // Save email
        if (responseData['email'] != null) {
          await _storage.write(key: 'email', value: responseData['email']);
        }

        // Save nama
        if (responseData['nama'] != null) {
          await _storage.write(key: 'nama', value: responseData['nama']);
        }

        // Save all user data as JSON
        await _storage.write(key: 'user_data', value: jsonEncode(responseData));

        return AuthResult(
          success: true,
          message: 'Login berhasil',
          user: responseData,
        );
      } else {
        // Login failed - ambil message dari "keterangan"
        final message = data['keterangan'] ?? 'Login gagal';
        return AuthResult(success: false, message: message);
      }
    } catch (e) {
      return AuthResult(success: false, message: 'Login failed: $e');
    }
  }

  /// Handle user logout
  Future<void> logout(BuildContext context) async {
    try {
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
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout error: $e'),
            backgroundColor: Colors.red,
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

  /// Get username
  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  /// Get email
  Future<String?> getEmail() async {
    return await _storage.read(key: 'email');
  }

  /// Get nama
  Future<String?> getNama() async {
    return await _storage.read(key: 'nama');
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
