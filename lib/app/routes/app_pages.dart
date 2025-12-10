import 'package:flutter/material.dart';
import 'package:cat_project/app/routes/app_routes.dart';
import 'package:cat_project/modules/splash/splash_screen.dart';
import 'package:cat_project/modules/auth/login/login_screen.dart';
import 'package:cat_project/modules/dashboard/dashboard_screen.dart';
import 'package:cat_project/modules/exam/exam_page.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

  static final routes = <String, WidgetBuilder>{
    AppRoutes.splash: (context) => const SplashScreen(),
    AppRoutes.login: (context) => const LoginScreen(),
    AppRoutes.dashboard: (context) => const DashboardScreen(),
    AppRoutes.exam: (context) => const ExamPage(
          examTitle: 'UJIAN - PILIHAN GANDA',
          examSubtitle: 'Ujian Kompetensi',
        ),
  };
}