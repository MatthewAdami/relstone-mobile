import '../config/api_config.dart';
import 'api_client.dart';

class CFPService {
  /// Fetch all CFP renewal data (state info, courses, and packages)
  /// Matches the web app's `getCFPData()` pattern
  static Future<Map<String, dynamic>> getCFPRenewalData() async {
    try {
      final result = await ApiClient.get(ApiConfig.cfpRenewal);
      final int status = result['statusCode'] as int? ?? 500;
      final Map<String, dynamic> data =
          result['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

      if (status < 200 || status >= 300) {
        final errorMsg = data['message'] ?? data['error'] ?? 'Failed to load CFP renewal data';
        throw Exception(errorMsg.toString());
      }

      // Support both {state,courses,packages} and {data:{...}} shapes
      final payload = data['data'] is Map
          ? (data['data'] as Map).cast<String, dynamic>()
          : data;

      // Extract state, courses, packages from response
      final stateData = payload['state'] as Map<String, dynamic>?;
      final coursesList = payload['courses'] as List? ?? [];
      var packagesList = payload['packages'] as List? ?? [];

      // Convert courses to proper maps
      final courses = coursesList
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // Convert packages to proper maps
      var packages = packagesList
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      // Fallback: if packages are empty, try the legacy packages endpoint
      if (packages.isEmpty) {
        final legacyPackages = await getCFPPackages();
        if (legacyPackages.isNotEmpty) {
          packages = legacyPackages;
        }
      }

      return {
        'success': true,
        'state': stateData,
        'courses': courses,
        'packages': packages,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString().replaceFirst('Exception: ', ''),
        'state': null,
        'courses': <Map<String, dynamic>>[],
        'packages': <Map<String, dynamic>>[],
      };
    }
  }

  /// Fetch only CFP packages (legacy endpoint for backwards compatibility)
  static Future<List<Map<String, dynamic>>> getCFPPackages() async {
    try {
      final result = await ApiClient.get(ApiConfig.cfpPackages);
      final int status = result['statusCode'] as int? ?? 500;
      final data = result['data'] as Map<String, dynamic>? ?? {};

      if (status < 200 || status >= 300) {
        throw Exception(data['message'] ?? 'Failed to load packages');
      }

      final packagesData = data['data'] is List ? data['data'] as List : [];
      return packagesData
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
