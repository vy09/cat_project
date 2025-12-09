# Environment Configuration Setup

## Overview

This project uses `.env` files to manage API credentials and configuration securely.

## Files Structure

### `.env` (Development)

- Used for local development
- Contains development API endpoints and keys
- **NEVER commit this file to Git**

### `.env.production` (Production)

- Used for production builds
- Contains production API endpoints and keys
- **NEVER commit this file to Git**

### `.env.example` (Template)

- Template file showing required environment variables
- Safe to commit to Git
- Use as reference for creating `.env` files

## Setup Instructions

### 1. Create Your Environment Files

Copy the example file to create your environment files:

```bash
# For development
cp .env.example .env

# For production
cp .env.example .env.production
```

### 2. Configure Your API Credentials

Edit `.env` and `.env.production` with your actual API credentials:

```env
# API Configuration
API_URL=https://your-api-url.com/api
API_KEY=your_actual_api_key_here

# Authentication
JWT_SECRET=your_jwt_secret_key_here

# Encryption
ENCRYPTION_KEY=your_32_character_encryption_key_here

# App Configuration
APP_ENV=production
DEBUG_MODE=false

# Timeout Settings
API_TIMEOUT=30
```

### 3. Important Security Notes

⚠️ **NEVER commit `.env` or `.env.production` to version control!**

These files are already added to `.gitignore`:

```gitignore
.env
.env.production
.env.staging
.env.local
```

## Environment Variables Reference

| Variable         | Description                          | Required | Example                            |
| ---------------- | ------------------------------------ | -------- | ---------------------------------- |
| `API_URL`        | Base URL for API endpoints           | ✅ Yes   | `https://api.example.com/api`      |
| `API_KEY`        | API authentication key               | ✅ Yes   | `your_api_key_12345`               |
| `JWT_SECRET`     | Secret for JWT token validation      | ✅ Yes   | `my_secret_jwt_key_xyz`            |
| `ENCRYPTION_KEY` | 32-character key for data encryption | ✅ Yes   | `12345678901234567890123456789012` |
| `APP_ENV`        | Application environment              | ✅ Yes   | `development` or `production`      |
| `DEBUG_MODE`     | Enable debug logging                 | No       | `true` or `false`                  |
| `API_TIMEOUT`    | API request timeout in seconds       | No       | `30`                               |

## Usage in Code

### Access Environment Variables

```dart
import 'package:cat_project/app/config/environment_config.dart';

// Get instance
final config = EnvironmentConfig();

// Access values
final apiUrl = config.apiUrl;
final apiKey = config.apiKey;
final isProduction = config.isProduction;
```

### API Client Usage

The `ApiClient` automatically uses environment configuration:

```dart
import 'package:cat_project/core/services/api_client.dart';

final apiClient = ApiClient();

// GET request
final response = await apiClient.get('/users');

// POST request
final response = await apiClient.post('/login', {
  'username': 'user@example.com',
  'password': 'password123',
});
```

### Authentication Service Usage

The `AuthService` handles login with API integration:

```dart
import 'package:cat_project/core/services/auth_service.dart';

final authService = AuthService();

// Login
final result = await authService.loginApi(
  username: 'user@example.com',
  password: 'password123',
);

if (result.success) {
  print('Login successful!');
  print('User: ${result.user}');
} else {
  print('Login failed: ${result.message}');
}

// Check if logged in
final isLoggedIn = await authService.isLoggedIn();

// Logout
await authService.logout(context);
```

## Building for Different Environments

### Development Build

```bash
flutter run
# Uses .env file by default
```

### Production Build

```bash
# Load production environment
flutter build apk --release
# Or specify environment file
flutter run --dart-define-from-file=.env.production
```

## Troubleshooting

### Environment not loading

1. Make sure `.env` file exists in project root
2. Check that file is properly formatted (no spaces around `=`)
3. Verify `pubspec.yaml` includes `.env` in assets
4. Run `flutter clean` and rebuild

### API requests failing

1. Verify `API_URL` is correct in `.env`
2. Check `API_KEY` is valid
3. Ensure network permissions in AndroidManifest.xml/Info.plist
4. Enable debug mode to see detailed error logs

### Configuration validation errors

1. Run app in debug mode to see validation messages
2. Check that all required variables are set
3. Ensure `ENCRYPTION_KEY` is at least 32 characters

## Security Best Practices

1. ✅ Use different API keys for development and production
2. ✅ Keep `.env` files in `.gitignore`
3. ✅ Never hardcode API keys in source code
4. ✅ Use strong, random encryption keys
5. ✅ Rotate API keys periodically
6. ✅ Use HTTPS for all API endpoints
7. ✅ Store sensitive tokens in `flutter_secure_storage`

## Files Created

- `.env` - Development environment variables
- `.env.production` - Production environment variables
- `.env.example` - Template for environment variables
- `lib/app/config/environment_config.dart` - Environment configuration service
- `lib/core/services/api_client.dart` - HTTP client with authentication
- `lib/core/services/auth_service.dart` - Authentication service with API integration

## Dependencies

Required packages (already added to `pubspec.yaml`):

- `flutter_dotenv: ^5.1.0` - Load environment variables
- `http: ^1.1.0` - HTTP requests
- `flutter_secure_storage: ^9.0.0` - Secure token storage
- `crypto: ^3.0.3` - Password hashing

Run `flutter pub get` to install dependencies.
