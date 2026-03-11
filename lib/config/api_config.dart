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

  // Auth
  static String get login    => "$baseUrl$apiPrefix/auth/login";
  static String get register => "$baseUrl$apiPrefix/auth/register";
  static String get health   => "$baseUrl$apiPrefix/health";
  static String get me       => "$baseUrl$apiPrefix/auth/me";          // ← ADD
  static String get myCourses => "$baseUrl$apiPrefix/auth/my-courses"; // ← ADD
  static String get googleMobile => "$baseUrl$apiPrefix/auth/google/mobile";


  

  // Exam  ← ADD ALL BELOW
 static String get examStart  => "$baseUrl$apiPrefix/exam-session/start";
  static String get examSubmit => "$baseUrl$apiPrefix/exam-session/submit";
  static String get examSave   => "$baseUrl$apiPrefix/exam-session/save"; // ← ADD THIS

  static String examSession(String studentId, String bundleId) =>
      "$baseUrl$apiPrefix/exam-session/bundle/$studentId/$bundleId";

  // Certificate  ← ADD ALL BELOW
  static String certDownload(String courseId) =>
      "$baseUrl$apiPrefix/certificate/download/$courseId";
  static String certStatus(String courseId) =>
      "$baseUrl$apiPrefix/certificate/status/$courseId";

  // Insurance (unchanged)
  static String get insuranceStates => "$baseUrl$apiPrefix/insurance/states";
  static String insuranceState(String slug) =>
      "$baseUrl$apiPrefix/insurance/states/${Uri.encodeComponent(slug)}";
  static String insuranceCourses(String slug) =>
      "$baseUrl$apiPrefix/insurance/courses/${Uri.encodeComponent(slug)}";
  static String insuranceStateFull(String slug) => insuranceState(slug);
}