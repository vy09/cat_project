import 'package:flutter/material.dart';

class AuthService {
  /// Handle user login
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Close loading dialog
    if (context.mounted) {
      Navigator.pop(context);
    }

    // TODO: Implement actual login logic here
    // For now, just show a success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil! Email: $email'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
    }
  }

  /// Handle user logout
  Future<void> logout(BuildContext context) async {
    // TODO: Implement logout logic
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
