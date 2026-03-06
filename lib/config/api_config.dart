import 'package:flutter/foundation.dart';

class ApiConfig {
  // Web uses localhost, Android emulator uses 10.0.2.2.
  // Backend is now running on port 3002
  static String get baseUrl =>
      kIsWeb ? "http://localhost:3002" : "http://10.0.2.2:3002";

  static const String apiPrefix = "/api/v1";

  // ✅ Your Node routes (based on server.js endpoints)
  static String get login => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health => "$baseUrl$apiPrefix/health";
  static String get insuranceStates => "$baseUrl$apiPrefix/insurance/states";
  static String insuranceStateFull(String slug) =>
      "$baseUrl$apiPrefix/insurance/$slug/full";
}