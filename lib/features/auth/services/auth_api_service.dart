import 'package:mentorme/core/api/base_api_client.dart';

class AuthApiService {
  /// Login user
  static Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    final body = {
      'email': email.trim(),
      'password': password.trim(),
      if (fcmToken != null) 'fcmToken': fcmToken,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/login/user',
      body: body,
    );

    return response;
  }

  /// Register user
  static Future<ApiResponse<Map<String, dynamic>>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final body = {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'confirmPassword': confirmPassword.trim(),
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/registration/user',
      body: body,
    );

    return response;
  }

  /// Logout user (if needed)
  static Future<ApiResponse<Map<String, dynamic>>> logout() async {
    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/logout',
    );

    return response;
  }

  /// Refresh token (if needed)
  static Future<ApiResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    final body = {
      'refreshToken': refreshToken,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/refresh-token',
      body: body,
    );

    return response;
  }

  /// Forgot password
  static Future<ApiResponse<Map<String, dynamic>>> forgotPassword({
    required String email,
  }) async {
    final body = {
      'email': email.trim(),
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/forgot-password',
      body: body,
    );

    return response;
  }

  /// Reset password
  static Future<ApiResponse<Map<String, dynamic>>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final body = {
      'token': token,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/reset-password',
      body: body,
    );

    return response;
  }

  /// Verify email
  static Future<ApiResponse<Map<String, dynamic>>> verifyEmail({
    required String token,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/verify-email',
      queryParams: {'token': token},
    );

    return response;
  }

  /// Resend verification email
  static Future<ApiResponse<Map<String, dynamic>>> resendVerificationEmail({
    required String email,
  }) async {
    final body = {
      'email': email.trim(),
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/resend-verification',
      body: body,
    );

    return response;
  }
}
