import 'package:flutter/material.dart';
import 'package:cat_project/core/services/splash_service.dart';
import 'package:cat_project/modules/splash/widgets/splash_logo_widget.dart';
import 'package:cat_project/modules/splash/widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final SplashService _splashService = SplashService();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _splashService.navigateToHome(context);
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: SplashService.animationDuration,
      vsync: this,
    );
    _fadeAnimation = _splashService.createFadeAnimation(_controller);
    _scaleAnimation = _splashService.createScaleAnimation(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SplashLogoWidget(),
                SizedBox(height: 40),
                LoadingIndicatorWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
