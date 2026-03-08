import '../config/api_config.dart';
import 'api_client.dart';

class InsuranceService {
  static Future<Map<String, dynamic>> fetchCoursesByStateSlug(
    String stateSlug,
  ) async {
    final result = await ApiClient.get(ApiConfig.insuranceStateFull(stateSlug));
    final int status = result['statusCode'] as int;
    final Map<String, dynamic> data =
        result['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    if (status < 200 || status >= 300) {
      return {
        'success': false,
        'message': data['message'] ?? 'Unable to load courses',
        'courses': <dynamic>[],
      };
    }

    final full = _extractFullData(data);
    final courses = full['courses'] is List ? full['courses'] as List : <dynamic>[];

    if (courses.isNotEmpty) {
      return {
        'success': true,
        'courses': courses,
      };
    }

    return {
      'success': true,
      'courses': <dynamic>[],
    };
  }

  static Future<Map<String, dynamic>> fetchStateWithCourses(String stateSlug) async {
    final stateResult = await ApiClient.get(ApiConfig.insuranceStateFull(stateSlug));
    final int stateStatus = stateResult['statusCode'] as int;
    final Map<String, dynamic> stateData =
        stateResult['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    if (stateStatus < 200 || stateStatus >= 300) {
      return {
        'success': false,
        'message': stateData['message'] ?? 'Unable to load state data',
      };
    }

    final full = _extractFullData(stateData);
    final state = full['state'] is Map
        ? (full['state'] as Map).cast<String, dynamic>()
        : <String, dynamic>{};
    final courses = full['courses'] is List ? full['courses'] as List : <dynamic>[];

    return {
      'success': true,
      'state': state,
      'courses': courses,
    };
  }

  static Map<String, dynamic> _extractFullData(Map<String, dynamic> data) {
    if (data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }

    if (data['data'] is Map) {
      return (data['data'] as Map).cast<String, dynamic>();
    }

    return data;
  }
}
