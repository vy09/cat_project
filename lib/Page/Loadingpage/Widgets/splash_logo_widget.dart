import 'package:flutter/material.dart';

class SplashLogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const SplashLogoWidget({super.key, this.width = 280, this.height = 280});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_bapeten.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
