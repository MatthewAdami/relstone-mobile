import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  static const int _timeoutSeconds = 15;

  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body ?? {}),
      ).timeout(
        const Duration(seconds: _timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Request timeout after $_timeoutSeconds seconds');
        },
      );

      // Sometimes backend returns HTML/errors; handle safely
      Map<String, dynamic> data;
      try {
        data = jsonDecode(res.body) as Map<String, dynamic>;
      } catch (_) {
        data = {'message': res.body};
      }

      return {
        'statusCode': res.statusCode,
        'data': data,
      };
    } catch (e) {
      // Return error response
      return {
        'statusCode': 0,
        'data': {
          'error': 'Connection Error',
          'message': e.toString(),
        },
      };
    }
  }

  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      ).timeout(
        const Duration(seconds: _timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Request timeout after $_timeoutSeconds seconds');
        },
      );

      Map<String, dynamic> data;
      try {
        data = jsonDecode(res.body) as Map<String, dynamic>;
      } catch (_) {
        data = {'message': res.body};
      }

      return {
        'statusCode': res.statusCode,
        'data': data,
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'data': {
          'error': 'Connection Error',
          'message': e.toString(),
        },
      };
    }
  }
}