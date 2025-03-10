import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentorme/global/global.dart';

class ProjectProvider extends ChangeNotifier {
  String? _selectedLearningPathId;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;

  String? get selectedLearningPathId => _selectedLearningPathId;
  List<Map<String, dynamic>> get projects => _projects;
  bool get isLoading => _isLoading;

  void setSelectedLearningPathId(String ID) {
    _selectedLearningPathId = ID;
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    if (_selectedLearningPathId == null) return;
    if (currentUserToken == null) {
      print('No auth token available');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // print('Fetching projects for learning path: $_selectedLearningPathId');
      // print('Using token: $currentUserToken');

      final response = await http.get(
        Uri.parse(
            'https://widgets-catb7yz54a-uc.a.run.app/api/learn/$_selectedLearningPathId'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['code'] == 200) {
          _projects = List<Map<String, dynamic>>.from(jsonData['data']);
          // print('Projects loaded successfully: ${_projects.length}');
        } else {
          // print('API returned error code: ${jsonData['code']}');
          _projects = [];
        }
      } else {
        // print('HTTP request failed with status: ${response.statusCode}');
        _projects = [];
      }
    } catch (e) {
      // print('Error fetching projects: $e');
      _projects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
