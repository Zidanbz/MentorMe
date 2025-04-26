import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentorme/core/config/env.dart';
import 'package:mentorme/global/global.dart';

class ProjectService {
  /// Fetch daftar project dalam learning path
  static Future<List<Map<String, dynamic>>> fetchLearnPath({
    required String learningPathId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/learn/$learningPathId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['code'] == 200) {
        return List<Map<String, dynamic>>.from(jsonData['data']);
      } else {
        throw Exception('Gagal mengambil data: ${jsonData['message']}');
      }
    } else {
      throw Exception('Gagal mengambil data. Kode: ${response.statusCode}');
    }
  }

  /// Fetch detail 1 project
  static Future<Map<String, dynamic>?> getProjectDetail({
    required String projectId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/learn/project/$projectId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['code'] == "OK" || jsonData['code'] == 200) {
        return Map<String, dynamic>.from(jsonData['data']);
      } else {
        throw Exception('API Error: ${jsonData['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }

  /// Fetch user learning IDs
  static Future<Set<String>> fetchUserLearningIDs(String token) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/user/learning-ids'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Set<String>.from(data['learningIds']);
    } else {
      throw Exception('Failed to load user learning IDs');
    }
  }
}
