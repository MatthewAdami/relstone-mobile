import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await ApiClient.post(
      ApiConfig.login,
      body: {'email': email.trim(), 'password': password},
    );

    final int status = result['statusCode'] as int;
    final Map<String, dynamic> data = result['data'] as Map<String, dynamic>;

    if (status == 200) {
      final token = data['token'];
      final user = data['user'];

      final prefs = await SharedPreferences.getInstance();
      if (token != null) await prefs.setString('token', token.toString());
      if (user != null) await prefs.setString('user', jsonEncode(user)); // ✅ was user.toString()

      return {
        'success': true,
        'user': user,
        'token': token, // ✅ was missing
      };
    }

    if (status == 403 && data['needsVerification'] == true) {
      return {
        'success': false,
        'needsVerification': true,
        'userId': data['userId']?.toString(),
        'message': data['message'] ?? 'Please verify your email.',
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Login failed',
    };
  }

  /// ✅ REGISTER: matches your backend /api/auth/register
  /// - 201: returns { message, userId }
  /// NOTE: Do NOT save token/user here because backend doesn't return them on register.
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

    if (status == 200 || status == 201) {
      return {
        'success': true,
        'userId': data['userId']?.toString(), // ✅ IMPORTANT for verify step
        'message': data['message'] ?? 'Account created. Please verify your email.',
      };
    }

    // Optional: in case you later change backend to send this
    if (status == 403 && data['needsVerification'] == true) {
      return {
        'success': false,
        'needsVerification': true,
        'userId': data['userId']?.toString(),
        'message': data['message'] ?? 'Please verify your email.',
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Registration failed',
      'errors': data['errors'],
    };
  }

  /// ✅ LOGOUT: used for sidebar logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  /// ✅ Optional helpers
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}