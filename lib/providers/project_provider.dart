import 'package:flutter/foundation.dart';
import 'package:mentorme/core/services/project_services.dart';
import 'package:mentorme/global/global.dart';

class ProjectProvider extends ChangeNotifier {
  String? _selectedLearningPathId;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;

  String? get selectedLearningPathId => _selectedLearningPathId;
  List<Map<String, dynamic>> get projects => _projects;
  bool get isLoading => _isLoading;

  get errorMessage => null;

  void setSelectedLearningPathId(String id) {
    _selectedLearningPathId = id;
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    if (_selectedLearningPathId == null || currentUserToken == null) {
      print('Learning Path atau Token kosong');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final data = await ProjectService.fetchLearnPath(
        learningPathId: _selectedLearningPathId!,
        token: currentUserToken!,
      );
      _projects = data;
    } catch (e) {
      print('Error: $e');
      _projects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
