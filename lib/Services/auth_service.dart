import 'package:flutter/material.dart';
import 'package:cat_project/Page/Dashboard/dashboard_screen.dart';

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
    // For now, just navigate to dashboard
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
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
