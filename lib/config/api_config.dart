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
  static String get insuranceStates => "$baseUrl$apiPrefix/insurance/states";
  static String insuranceState(String slug) =>
      "$baseUrl$apiPrefix/insurance/states/${Uri.encodeComponent(slug)}";
  static String insuranceCourses(String slug) =>
      "$baseUrl$apiPrefix/insurance/courses/${Uri.encodeComponent(slug)}";

  static String insuranceStateFull(String slug) => insuranceState(slug);
}