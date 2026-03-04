import 'package:flutter/foundation.dart';

class ApiConfig {
  // Web uses localhost, Android emulator uses 10.0.2.2.
  static String get baseUrl =>
      kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";

  static const String apiPrefix = "/api";

  // ✅ Your Node routes (based on server.js: app.use('/api/auth', ...))
  static String get login => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health => "$baseUrl$apiPrefix/health";
  static String get insuranceStates => "$baseUrl$apiPrefix/insurance/states";
}