import 'package:flutter/material.dart';
import 'package:cat_project/modules/auth/login/login_screen.dart';

class SplashService {
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 1500);

  /// Navigate to login screen after delay
  Future<void> navigateToHome(BuildContext context) async {
    await Future.delayed(splashDuration);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  /// Setup fade animation
  Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
  }

  /// Setup scale animation
  Animation<double> createScaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
  }
}
