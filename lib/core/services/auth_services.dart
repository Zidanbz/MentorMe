import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentorme/core/config/env.dart';

class AuthService {
  static const String _baseUrl = Env.baseUrl;

// Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String? fcmToken,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login/user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email.trim(),
        'password': password.trim(),
        'fcmToken': fcmToken,
      }),
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Terjadi kesalahan saat login');
    }
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/registration/user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName.trim(),
          'email': email.trim(),
          'password': password.trim(),
          'confirmPassword': confirmPassword.trim(),
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['error'] ?? 'Terjadi kesalahan saat mendaftar');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }
}
