import 'package:mentorme/core/api/base_api_client.dart';

class ProfileApiService {
  /// Fetch user profile
  static Future<ApiResponse<Map<String, dynamic>>> fetchProfile() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/profile/get',
    );

    return response;
  }

  /// Update user profile
  static Future<ApiResponse<Map<String, dynamic>>> updateProfile({
    required String fullName,
    String? email,
    String? phone,
    String? bio,
  }) async {
    final body = <String, dynamic>{
      'fullName': fullName.trim(),
    };

    if (email != null) body['email'] = email.trim();
    if (phone != null) body['phone'] = phone.trim();
    if (bio != null) body['bio'] = bio.trim();

    final response = await BaseApiClient.put<Map<String, dynamic>>(
      '/profile/update',
      body: body,
    );

    return response;
  }

  /// Update profile picture
  static Future<ApiResponse<Map<String, dynamic>>> updateProfilePicture({
    required String imagePath,
  }) async {
    final response = await BaseApiClient.multipartRequest<Map<String, dynamic>>(
      '/profile/update-picture',
      'PUT',
      files: {'picture': imagePath},
    );

    return response;
  }

  /// Fetch profile history/transactions
  static Future<ApiResponse<Map<String, dynamic>>> fetchProfileHistory() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/profile/history',
    );

    return response;
  }

  /// Fetch user coin balance
  static Future<ApiResponse<Map<String, dynamic>>> fetchCoin() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/coin/get',
    );

    return response;
  }

  /// Fetch user learning data
  static Future<ApiResponse<Map<String, dynamic>>> fetchUserLearning() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/my/learning',
    );

    return response;
  }

  /// Change password
  static Future<ApiResponse<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final body = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    final response = await BaseApiClient.put<Map<String, dynamic>>(
      '/profile/change-password',
      body: body,
    );

    return response;
  }

  /// Delete account
  static Future<ApiResponse<Map<String, dynamic>>> deleteAccount({
    required String password,
  }) async {
    final body = {
      'password': password,
    };

    final response = await BaseApiClient.delete<Map<String, dynamic>>(
      '/profile/delete',
    );

    return response;
  }

  /// Update notification settings
  static Future<ApiResponse<Map<String, dynamic>>> updateNotificationSettings({
    required bool emailNotifications,
    required bool pushNotifications,
    required bool smsNotifications,
  }) async {
    final body = {
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
    };

    final response = await BaseApiClient.put<Map<String, dynamic>>(
      '/profile/notification-settings',
      body: body,
    );

    return response;
  }

  /// Fetch notification settings
  static Future<ApiResponse<Map<String, dynamic>>>
      fetchNotificationSettings() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/profile/notification-settings',
    );

    return response;
  }
}
