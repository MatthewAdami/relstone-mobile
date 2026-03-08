import '../config/api_config.dart';
import 'api_client.dart';

class InsuranceService {
  static Future<Map<String, dynamic>> fetchCoursesByStateSlug(
    String stateSlug,
  ) async {
    final result = await ApiClient.get(ApiConfig.insuranceCourses(stateSlug));
    final int status = result['statusCode'] as int;
    final Map<String, dynamic> data = result['data'] as Map<String, dynamic>;

    if (status != 200) {
      return {
        'success': false,
        'message': data['message'] ?? 'Unable to load courses',
        'courses': <dynamic>[],
      };
    }

    if (data['courses'] is List) {
      return {
        'success': true,
        'courses': data['courses'] as List,
      };
    }

    if (data['success'] == true && data['data'] is List) {
      return {
        'success': true,
        'courses': data['data'] as List,
      };
    }

    return {
      'success': true,
      'courses': <dynamic>[],
    };
  }

  static Future<Map<String, dynamic>> fetchStateWithCourses(String stateSlug) async {
    final stateResult = await ApiClient.get(ApiConfig.insuranceState(stateSlug));
    final int stateStatus = stateResult['statusCode'] as int;
    final Map<String, dynamic> stateData =
        stateResult['data'] as Map<String, dynamic>;

    if (stateStatus != 200) {
      return {
        'success': false,
        'message': stateData['message'] ?? 'Unable to load state data',
      };
    }

    Map<String, dynamic> state = <String, dynamic>{};
    List<dynamic> courses = <dynamic>[];

    if (stateData['state'] is Map) {
      state = (stateData['state'] as Map).cast<String, dynamic>();
    }
    if (stateData['courses'] is List) {
      courses = stateData['courses'] as List;
    }

    if (state.isEmpty && stateData['success'] == true && stateData['data'] is Map) {
      state = (stateData['data'] as Map).cast<String, dynamic>();
    }

    if (courses.isEmpty && stateData['success'] == true && stateData['data'] is List) {
      courses = stateData['data'] as List;
    }

    if (courses.isEmpty) {
      final coursesResult = await ApiClient.get(ApiConfig.insuranceCourses(stateSlug));
      final int coursesStatus = coursesResult['statusCode'] as int;
      final Map<String, dynamic> coursesData =
          coursesResult['data'] as Map<String, dynamic>;

      if (coursesStatus == 200) {
        if (coursesData['courses'] is List) {
          courses = coursesData['courses'] as List;
        } else if (coursesData['success'] == true && coursesData['data'] is List) {
          courses = coursesData['data'] as List;
        }
      }
    }

    return {
      'success': true,
      'state': state,
      'courses': courses,
    };
  }
}
