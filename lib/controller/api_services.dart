import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mentorme/models/Profile_models.dart';
import 'package:mentorme/global/global.dart';
import 'package:mentorme/models/learning_model.dart';
import 'package:mentorme/models/mainScreen_models.dart';

class ApiService {
  final String baseUrl =
      'https://widgets22-catb7yz54a-et.a.run.app/api'; // Ganti dengan URL API Anda

  Future<Profile?> fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/get'),
        headers: {
          'Authorization':
              'Bearer $currentUserToken', // Gunakan token yang valid
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("Response Data: $responseData");
        if (responseData['code'] == 200 && responseData['data'] != null) {
          final profileData = responseData['data'];

          // Pastikan picture URL yang diterima benar
          final pictureUrl = profileData['picture'] ?? '';

          // Cek apakah URL valid atau tidak
          final validPictureUrl = Uri.tryParse(pictureUrl)?.isAbsolute == true
              ? pictureUrl
              : 'assets/person.png'; // Gambar default

          return Profile(
            fullName: profileData['fullName'] ?? '',
            picture: validPictureUrl, // Gunakan URL yang valid
          );
        } else {
          print('Error: ${responseData['message']}');
          return null;
        }
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Getname?> fetchName() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/get'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['code'] == 200 && responseData['data'] != null) {
          final profileData = responseData['data'];

          Uint8List? imageBytes;
          if (profileData['picture'] != null) {
            // Ambil file gambar dari API
            final imageResponse =
                await http.get(Uri.parse(profileData['picture']));
            if (imageResponse.statusCode == 200) {
              imageBytes = imageResponse.bodyBytes; // Simpan dalam Uint8List
            }
          }

          return Getname(
            fullName: profileData['fullName'] ?? '',
            picture: imageBytes,
          );
        } else {
          print('Error: ${responseData['message']}');
          return null;
        }
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<int> fetchCoin() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coin/get'),
        headers: {
          'Authorization': 'Bearer $currentUserToken', // Jika diperlukan
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['code'] == 200 && jsonResponse['error'] == null) {
          final int coinBalance = jsonResponse['data']['coin'];
          return coinBalance;
        } else {
          throw Exception(
              'Gagal mengambil saldo koin: ${jsonResponse['error']}');
        }
      } else {
        throw Exception('Gagal mengambil saldo koin: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil saldo koin: $e');
    }
  }

  Future<List<Learning>?> fetchUserLearning() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/my/learning'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['code'] == 200 && responseData['data'] != null) {
          // Pastikan untuk mengakses daftar dengan benar
          List<Learning> learnings = (responseData['data']['learning'] as List)
              .map((item) => Learning.fromJson(item))
              .toList();
          return learnings;
        } else {
          print('No learning data available');
          return [];
        }
      } else {
        print('Failed to fetch learning data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching learning data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getTransactionHistory() async {
    final String url = '$baseUrl/profile/history';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "code": response.statusCode,
          "error": "Failed to fetch data",
          "data": null,
          "message": response.reasonPhrase,
        };
      }
    } catch (e) {
      return {
        "code": 500,
        "error": e.toString(),
        "data": null,
        "message": "Internal Server Error",
      };
    }
  }

  static Future<Set<String>> fetchUserLearningIDs() async {
    try {
      final response = await http.get(
        Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/my/learning'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['code'] == 200 && responseData['data'] != null) {
          Set<String> learningIDs = (responseData['data'] as List)
              .map<String>((item) => item['learning']['IDProject'])
              .toSet();
          return learningIDs;
        }
      }
    } catch (e) {
      print('Error fetching user learning IDs: $e');
    }
    return {};
  }

  Future<Map<String, dynamic>> fetchProfileHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/history'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['code'] == 200) {
          return responseData['data']; // Kembalikan langsung data history
        } else {
          return {"error": responseData['error'] ?? "Unknown error"};
        }
      } else {
        return {"error": "Failed to fetch data: ${response.statusCode}"};
      }
    } catch (e) {
      return {"error": "Internal Server Error: $e"};
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Authorization':
              'Bearer $currentUserToken', // Sesuaikan token yang digunakan
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['code'] == 200 && responseData['data'] != null) {
          // Mengembalikan data categories
          List<Map<String, dynamic>> categories =
              List<Map<String, dynamic>>.from(responseData['data']);
          return categories;
        } else {
          print('Error: ${responseData['message']}');
          return [];
        }
      } else {
        print('Failed to load categories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchLearnPaths() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all/learnpath'),
        headers: {
          'Authorization':
              'Bearer $currentUserToken', // Sesuaikan token yang digunakan
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['code'] == 200 && responseData['data'] != null) {
          // Mengembalikan data learnpath
          List<Map<String, dynamic>> learnPaths =
              List<Map<String, dynamic>>.from(responseData['data']);
          return learnPaths;
        } else {
          print('Error: ${responseData['message']}');
          return [];
        }
      } else {
        print('Failed to load learn paths: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
