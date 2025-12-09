import 'package:flutter/material.dart';
import 'package:cat_project/app/theme/app_theme.dart';
import 'package:cat_project/app/routes/app_pages.dart';
import 'package:cat_project/app/constants/app_constants.dart';
import 'package:cat_project/app/config/environment_config.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  try {
    await EnvironmentConfig.initialize();

    // Validate configuration
    final config = EnvironmentConfig();
    if (!config.validateConfig()) {
      debugPrint('Warning: Environment configuration has errors');
    }

    // Print config in debug mode
    config.printConfig();
  } catch (e) {
    debugPrint('Error loading environment configuration: $e');
  }

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
