import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentorme/global/global.dart';

class GetProjectProvider extends ChangeNotifier {
  static const String baseUrl = 'https://widgets-catb7yz54a-uc.a.run.app';

  List<dynamic> _projects = [];
  bool _isLoading = false;

  List<dynamic> get projects => _projects;
  bool get isLoading => _isLoading;

  Future<void> fetchAllProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/project/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Decode base64 images here:
        _projects = (responseData['data'] as List).map((project) {
          if (project['picture'] != null) {
            try {
              project['decodedImage'] = base64Decode(project['picture']);
            } catch (e) {
              print('Error decoding image: $e');
              // Handle decoding error, e.g., set a placeholder image.
              project['decodedImage'] = null; // or a default image
            }
          }
          return project;
        }).toList();
      } else {
        throw Exception(responseData['error'] ?? 'Failed to load projects');
      }
    } catch (e) {
      print('Error fetching projects: $e'); // Print the error for debugging
      throw Exception('Failed to connect to server: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
