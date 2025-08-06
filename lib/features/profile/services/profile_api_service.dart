import 'package:mentorme/core/api/base_api_client.dart';

class ProfileApiService {
  /// Fetch user profile
  static Future<ApiResponse<Map<String, dynamic>>> fetchProfile() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/profile/get',
    );

    return response;
  }

  /// [PERBAIKAN]
  /// Mengupdate profil pengguna (teks dan gambar dalam satu request).
  /// Fungsi ini selalu menggunakan multipart/form-data.
  static Future<ApiResponse<Map<String, dynamic>>> updateProfile({
    required String fullName,
    String? phone,
    String? imagePath, // Parameter untuk path gambar (opsional)
  }) async {
    // Siapkan field teks
    final fields = <String, String>{
      'fullName': fullName.trim(),
    };
    if (phone != null) {
      fields['phone'] = phone.trim();
    }

    // Siapkan file jika ada
    final files = <String, String>{};
    if (imagePath != null && imagePath.isNotEmpty) {
      // 'picture' adalah key yang diharapkan oleh backend Anda
      files['picture'] = imagePath;
    }

    // Gunakan multipartRequest untuk mengirim keduanya
    final response = await BaseApiClient.multipartRequest<Map<String, dynamic>>(
      // Pastikan endpoint ini benar sesuai routing backend Anda
      '/profile/edit',
      'PUT',
      fields: fields,
      files: files,
    );

    return response;
  }

  /*
    Fungsi updateProfilePicture sudah tidak diperlukan karena logikanya
    telah digabungkan ke dalam fungsi updateProfile di atas.
  */

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
      // Seharusnya body dikirim di sini jika API Anda mengharapkannya
      // body: body,
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
