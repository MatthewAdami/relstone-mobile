class ApiConfig {
  // ✅ Choose ONE depending on how you run your app:

  // Windows Desktop (currently running):
  static const String baseUrl = "http://localhost:5000";

  // Android Emulator -> points to your PC localhost
  // static const String baseUrl = "http://10.0.2.2:5000";

  // iOS Simulator:
  // static const String baseUrl = "http://localhost:5000";

  // Real device (phone) -> use your PC IP (same WiFi)
  // static const String baseUrl = "http://192.168.100.3:5000";

  static const String apiPrefix = "/api/v1";

  // ✅ Your Node routes (based on server.js using /api/v1 prefix)
  static String get login => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health => "$baseUrl$apiPrefix/health";
}