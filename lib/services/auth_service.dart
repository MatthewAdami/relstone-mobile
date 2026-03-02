import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await ApiClient.post(
      ApiConfig.login,
      body: {'email': email, 'password': password},
    );

    final int status = result['statusCode'] as int;
    final Map<String, dynamic> data = result['data'] as Map<String, dynamic>;

    if (status == 200) {
      final token = data['token'];
      final user = data['user'];

      final prefs = await SharedPreferences.getInstance();
      if (token != null) await prefs.setString('token', token.toString());
      if (user != null) await prefs.setString('user', user.toString());

      return {'success': true, 'user': user};
    }

    // Example: if your backend sends needsVerification
    if (status == 403 && data['needsVerification'] == true) {
      return {
        'success': false,
        'needsVerification': true,
        'userId': data['userId'],
        'message': data['message'] ?? 'Email not verified',
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Login failed',
    };
  }
}