
import 'dart:convert';
import 'package:http/http.dart' as http;

class LearnPathService {
  static const String _baseUrl =
      'https://widgets22-catb7yz54a-et.a.run.app'; // Ganti dengan base URL API kamu

  // Fungsi untuk mengambil semua learning path
  static Future<List<Map<String, dynamic>>> getAllLearningPaths() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/all/learnpath'),
      // headers: {'Content-Type': 'application/json'},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      // Parsing data jika status code 200
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    } else {
      throw Exception(data['error'] ??
          'Terjadi kesalahan saat mengambil data learning path');
    }
  }
}
