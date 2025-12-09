import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../app/config/environment_config.dart';

/// API Client Service
/// Handles all HTTP requests with authentication and error handling
class ApiClient {
  final EnvironmentConfig _config = EnvironmentConfig();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  /// Get base headers for API requests
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Key': _config.apiKey,
    };

    if (includeAuth) {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// GET request
  Future<ApiResponse> get(String endpoint, {bool includeAuth = true}) async {
    try {
      final url = Uri.parse('${_config.apiUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .get(url, headers: headers)
          .timeout(Duration(seconds: _config.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 0,
      );
    }
  }

  /// POST request
  Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('${_config.apiUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(Duration(seconds: _config.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 0,
      );
    }
  }

  /// PUT request
  Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('${_config.apiUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(Duration(seconds: _config.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 0,
      );
    }
  }

  /// DELETE request
  Future<ApiResponse> delete(String endpoint, {bool includeAuth = true}) async {
    try {
      final url = Uri.parse('${_config.apiUrl}$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await http
          .delete(url, headers: headers)
          .timeout(Duration(seconds: _config.apiTimeout));

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 0,
      );
    }
  }

  /// Handle HTTP response
  ApiResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    try {
      final data = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};

      if (statusCode >= 200 && statusCode < 300) {
        return ApiResponse(
          success: true,
          data: data,
          message: data['message'] ?? 'Success',
          statusCode: statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          data: data,
          message: data['message'] ?? 'Request failed',
          statusCode: statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to parse response: $e',
        statusCode: statusCode,
      );
    }
  }
}

/// API Response Model
class ApiResponse {
  final bool success;
  final dynamic data;
  final String message;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
  }
}
