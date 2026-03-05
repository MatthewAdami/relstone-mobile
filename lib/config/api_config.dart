import 'package:flutter/foundation.dart';

class ApiConfig {
  // Android Emulator -> points to your PC localhost
  static const String baseUrl  = "http://10.0.2.2:5000";
  static const String adminUrl = "http://10.0.2.2:8000";

  // iOS Simulator:
  // static const String baseUrl = "http://localhost:5000";

  // Real device (phone) -> use your PC IP (same WiFi)
  // static const String baseUrl = "http://192.168.100.3:5000";

  static const String apiPrefix = "/api";

  // ── Auth ──────────────────────────────────────────────────
  static String get login    => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health   => "$baseUrl$apiPrefix/health";

  // ── Admin DB (port 8000) ──────────────────────────────────
  static String get students => "$adminUrl/api/students";

  // ── Insurance ─────────────────────────────────────────────
  static String get insuranceStates => "$baseUrl$apiPrefix/insurance/states";
  static String insuranceStateFull(String slug) =>
      "$baseUrl$apiPrefix/insurance/$slug/full";
}