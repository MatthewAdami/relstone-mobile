import 'package:flutter/foundation.dart';

class ApiConfig {
  // Android emulator must use 10.0.2.2; web/desktop use localhost.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  static const String apiPrefix = "/api";

  // Backend routes are served under /api in current local setup.
  static String get login => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health => "$baseUrl$apiPrefix/health";
}