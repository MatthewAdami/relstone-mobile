import 'package:flutter/foundation.dart';

class ApiConfig {
<<<<<<< HEAD
  // ✅ Choose ONE depending on how you run your app:

  // Android Emulator -> points to your PC localhost
  static const String baseUrl = "http://10.0.2.2:5000";

  // iOS Simulator:
  // static const String baseUrl = "http://localhost:5000";

  // Real device (phone) -> use your PC IP (same WiFi)
  // static const String baseUrl = "http://192.168.100.3:5000";
static const String adminUrl = "http://10.0.2.2:8000";
=======
  // Web uses localhost, Android emulator uses 10.0.2.2.
  static String get baseUrl =>
      kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";
>>>>>>> 8d920e3b1b9adeec7b96a156b594f71235330096

  static const String apiPrefix = "/api";

  // ✅ Your Node routes (based on server.js: app.use('/api/auth', ...))
  static String get login => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health => "$baseUrl$apiPrefix/health";
<<<<<<< HEAD
  static String get students => "$adminUrl/api/students";
=======
  static String get insuranceStates => "$baseUrl$apiPrefix/insurance/states";
  static String insuranceStateFull(String slug) =>
      "$baseUrl$apiPrefix/insurance/$slug/full";
>>>>>>> 8d920e3b1b9adeec7b96a156b594f71235330096
}