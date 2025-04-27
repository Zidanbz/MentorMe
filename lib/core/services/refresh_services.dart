import 'package:mentorme/controller/api_services.dart';
import 'package:mentorme/models/Profile_models.dart';

class RefreshService {
  static Future<Profile?> refreshProfile() async {
    try {
      final profile = await ApiService().fetchProfile();
      return profile;
    } catch (e) {
      print('Error saat refresh profile: $e');
      return null;
    }
  }

  // Tambahkan method lain kalau mau refresh data lain
}
