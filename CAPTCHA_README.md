# Captcha Widget Documentation

## Overview

Widget captcha sederhana untuk validasi login dengan fitur:

- Generate kode captcha acak (6 karakter)
- Visual dengan noise pattern untuk keamanan
- Refresh button untuk generate ulang
- Real-time validation
- Feedback visual untuk user

## Files Created

1. `lib/modules/auth/login/widgets/captcha_widget.dart` - Widget utama captcha
2. `lib/core/services/captcha_service.dart` - Service untuk mengelola state captcha
3. `lib/modules/auth/login/widgets/widgets.dart` - Export file untuk widgets

## Usage

```dart
CaptchaWidget(
  onValidationChanged: (bool isValid) {
    // Handle validation state change
    setState(() {
      _isCaptchaValid = isValid;
    });
  },
  onRefresh: () {
    // Handle captcha refresh
    setState(() {
      _isCaptchaValid = false;
    });
  },
)
```

## Features

- ✅ Random 6-character alphanumeric code
- ✅ Custom painter for visual noise
- ✅ Real-time validation
- ✅ Refresh functionality
- ✅ Visual feedback (green/red icons)
- ✅ Integrated with login form validation

## Integration

Captcha telah diintegrasikan ke dalam `login_screen.dart`:

- Muncul setelah field password
- Login button hanya aktif jika captcha valid
- Show error message jika captcha belum valid
- Auto reset setelah login berhasil
