import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mentorme/models/Profile_models.dart';
import 'package:mentorme/global/global.dart';
import 'package:mentorme/models/mainScreen_models.dart';

class ApiService {
  final String baseUrl =
      'https://widgets-catb7yz54a-uc.a.run.app/api'; // Ganti dengan URL API Anda

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

        if (responseData['code'] == 200 && responseData['data'] != null) {
          final profileData = responseData['data'];
          return Profile(
            fullName: profileData['fullName'] ?? '',
            picture: profileData['picture'] ?? '', // Mengambil URL gambar
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
}
