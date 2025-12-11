import 'package:flutter/material.dart';
import 'package:cat_project/core/services/auth_service.dart';
import 'package:cat_project/core/services/captcha_service.dart';
import 'package:cat_project/modules/auth/login/widgets/captcha_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _captchaService = CaptchaService();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isCaptchaValid = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate() && _isCaptchaValid) {
      _authService.login(
        context,
        _usernameController.text,
        _passwordController.text,
        _rememberMe,
      );
      // Reset captcha after successful login attempt
      _captchaService.resetCaptcha();
    } else if (!_isCaptchaValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan lengkapi verifikasi captcha'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onCaptchaValidationChanged(bool isValid) {
    setState(() {
      _isCaptchaValid = isValid;
    });
  }

  void _onCaptchaRefresh() {
    setState(() {
      _isCaptchaValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF6366F1),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet
                        ? constraints.maxWidth * 0.2
                        : screenWidth * 0.06,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isSmallScreen ? 10 : 20),
                      // Logo BAPETEN
                      Container(
                        width: isSmallScreen
                            ? 80
                            : isTablet
                            ? 100
                            : 90,
                        height: isSmallScreen
                            ? 80
                            : isTablet
                            ? 100
                            : 90,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/logo/logo_bapeten.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 25),
                      // Title
                      Text(
                        'UJIAN BERBASIS KOMPUTER',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: isSmallScreen
                              ? 14
                              : isTablet
                              ? 18
                              : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isSmallScreen ? 3 : 5),
                      Text(
                        'PETUGAS BIDANG KETENAGA NUKLIRAN',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: isSmallScreen
                              ? 13
                              : isTablet
                              ? 16
                              : 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                      // Login Form Card
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 500 : double.infinity,
                        ),
                        padding: EdgeInsets.all(
                          isSmallScreen
                              ? 12
                              : isTablet
                              ? 20
                              : 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 24 : 20,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Login Title
                              Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: isSmallScreen
                                        ? 18
                                        : isTablet
                                        ? 24
                                        : 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 2 : 4),
                              Center(
                                child: Text(
                                  'Hi Selamat datang kembali ke akun anda',
                                  style: TextStyle(
                                    fontSize: isSmallScreen
                                        ? 11
                                        : isTablet
                                        ? 14
                                        : 12,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              // Email/Username Field
                              Text(
                                'Email / Username',
                                style: TextStyle(
                                  fontSize: isSmallScreen
                                      ? 12
                                      : isTablet
                                      ? 15
                                      : 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 3 : 4),
                              TextFormField(
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan email atau username',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 18 : 14,
                                    vertical: isSmallScreen
                                        ? 8
                                        : isTablet
                                        ? 12
                                        : 10,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email atau username tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              // Password Field
                              Text(
                                'Kata Sandi',
                                style: TextStyle(
                                  fontSize: isSmallScreen
                                      ? 12
                                      : isTablet
                                      ? 15
                                      : 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 3 : 4),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 18 : 14,
                                    vertical: isSmallScreen
                                        ? 8
                                        : isTablet
                                        ? 12
                                        : 10,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[600],
                                      size: isTablet ? 24 : 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  if (value.length < 6) {
                                    return 'Password minimal 6 karakter';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: isSmallScreen ? 6 : 8),
                              // Captcha Widget
                              CaptchaWidget(
                                onValidationChanged:
                                    _onCaptchaValidationChanged,
                                onRefresh: _onCaptchaRefresh,
                              ),
                              SizedBox(height: isSmallScreen ? 2 : 4),
                              // Remember Me Checkbox
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: isSmallScreen
                                        ? 0.8
                                        : isTablet
                                        ? 1.1
                                        : 0.9,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: const Color(0xFF6366F1),
                                    ),
                                  ),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                      fontSize: isSmallScreen
                                          ? 12
                                          : isTablet
                                          ? 16
                                          : 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6366F1),
                                    padding: EdgeInsets.symmetric(
                                      vertical: isSmallScreen
                                          ? 12
                                          : isTablet
                                          ? 18
                                          : 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        isTablet ? 16 : 12,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Masuk',
                                    style: TextStyle(
                                      fontSize: isSmallScreen
                                          ? 14
                                          : isTablet
                                          ? 18
                                          : 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
