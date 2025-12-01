import 'package:flutter/material.dart';
import 'package:cat_project/app/theme/app_theme.dart';
import 'package:cat_project/app/routes/app_pages.dart';
import 'package:cat_project/app/constants/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      routes: AppPages.routes,
    );
  }
}
