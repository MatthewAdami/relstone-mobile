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

  // ✅ ADD THIS
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final result = await ApiClient.post(
      ApiConfig.register,
      body: {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'email': email.trim(),
        'password': password,
      },
    );

    final int status = result['statusCode'] as int;
    final Map<String, dynamic> data = result['data'] as Map<String, dynamic>;

    // Common success statuses: 200 or 201
    if (status == 200 || status == 201) {
      // If your backend returns token+user on register:
      final token = data['token'];
      final user = data['user'];

      final prefs = await SharedPreferences.getInstance();
      if (token != null) await prefs.setString('token', token.toString());
      if (user != null) await prefs.setString('user', user.toString());

      return {
        'success': true,
        'user': user,
        'message': data['message'] ?? 'Registered successfully',
      };
    }

    // If your backend requires email verification and returns something like:
    // { needsVerification: true, userId: "...", message: "..." }
    if (status == 403 && data['needsVerification'] == true) {
      return {
        'success': false,
        'needsVerification': true,
        'userId': data['userId'],
        'message': data['message'] ?? 'Please verify your email',
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Registration failed',
      'errors': data['errors'],
    };
  }

  // ✅ OPTIONAL helper for logout (used in sidebar)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }
}