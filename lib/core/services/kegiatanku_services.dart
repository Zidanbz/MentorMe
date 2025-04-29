import 'dart:convert';
import 'package:mentorme/core/services/api_services.dart';
import 'package:mentorme/global/global.dart';

class ActivityService {
  static final _api = ApiService();

  // Fetch learning data, improved error handling
  static Future<List<Map<String, dynamic>>> fetchLearningData() async {
    try {
      final response = await _api.get('/my/learning', token: currentUserToken);
      print('Learning response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['data'] != null &&
            data['data'] is Map &&
            data['data'].containsKey('learning') &&
            data['data']['learning'] is List) {
          return List<Map<String, dynamic>>.from(data['data']['learning']);
        } else {
          throw Exception('Format data tidak sesuai: ${data['data']}');
        }
      } else {
        throw Exception(
            'Failed to load learning data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('fetchLearningData ERROR: $e');
      rethrow; // Re-throw the error after logging it
    }
  }

  // Fetch activity progress with status code check
  static Future<double> fetchActivityProgress(String idProject) async {
    try {
      final response =
          await _api.get('/my/activity/$idProject', token: currentUserToken);
      print('Activity response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final trainList = data['data']?['train'];
        if (trainList is List) {
          int total = trainList.length;
          int completed = trainList.where((t) {
            final status = t['trainActivity']?['status'];
            return status == true || status.toString() == 'true';
          }).length;

          return total > 0 ? completed / total : 0.0;
        } else {
          throw Exception('Data "train" bukan list: ${trainList}');
        }
      } else {
        throw Exception(
            'Gagal mengambil progress aktivitas. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('fetchActivityProgress ERROR: $e');
      rethrow;
    }
  }

  // Fetch activity details, improved error handling
  static Future<Map<String, dynamic>> fetchActivityDetails(
      String activityId) async {
    if (activityId.isEmpty) {
      throw Exception("Invalid activity ID");
    }

    try {
      final response = await _api.get(
        '/my/activity/$activityId',
        token: currentUserToken,
      );
      print(
          'Activity details response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['data'] != null && data['data'] is Map) {
          return data['data'];
        } else {
          throw Exception('Format data tidak sesuai: ${data['data']}');
        }
      } else {
        throw Exception(
            'Failed to load activity details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('fetchActivityDetails ERROR: $e');
      rethrow; // Re-throw the error after logging it
    }
  }

  static Future<bool> hasUserPurchasedProject(String projectId) async {
    try {
      final learningData = await fetchLearningData(); // Ambil data learning
      // Cek apakah IDProject ada dalam data learning
      for (var learningItem in learningData) {
        if (learningItem['IDProject'] == projectId) {
          return true; // Proyek sudah dibeli
        }
      }
      return false; // Proyek belum dibeli
    } catch (e) {
      print('Error checking if project is purchased: $e');
      return false; // Jika gagal, anggap belum dibeli
    }
  }
}
