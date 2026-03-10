import 'package:flutter/foundation.dart';

class ApiConfig {
    static const String _envBaseUrl = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: '',
    );

    // URL rules:
    // - Web + Windows/macOS/Linux + iOS simulator/device: localhost
    // - Android emulator: 10.0.2.2 maps host loopback
    // - API_BASE_URL (dart-define) overrides everything for remote/back-end hosts
    static String get baseUrl {
        if (_envBaseUrl.isNotEmpty) return _envBaseUrl;

        if (kIsWeb) return 'http://localhost:5000';

        return defaultTargetPlatform == TargetPlatform.android
                ? 'http://10.0.2.2:5000'
                : 'http://localhost:5000';
    }

  static const String apiPrefix = "/api";

  // ✅ Your Node routes (based on server.js: app.use('/api/auth', ...))
  static String get login => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health => "$baseUrl$apiPrefix/health";
  static String get insuranceStates => "$baseUrl$apiPrefix/insurance/states";
  static String insuranceStateFull(String slug) =>
      "$baseUrl$apiPrefix/insurance/states/$slug";
}