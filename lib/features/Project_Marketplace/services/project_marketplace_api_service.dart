import 'package:mentorme/core/api/base_api_client.dart';

class ProjectMarketplaceApiService {
  static const String _baseEndpoint = '/project';

  /// Fetch all projects in marketplace
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchAllProjects() async {
    final response =
        await BaseApiClient.get<Map<String, dynamic>>('$_baseEndpoint/all');

    if (response.success && response.data != null) {
      final List<dynamic> projectList =
          response.data!['projects'] ?? response.data!;
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(projectList),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch project detail by ID
  static Future<ApiResponse<Map<String, dynamic>>> getProjectDetail({
    required String projectId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
        '/learn/project/$projectId');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: response.data!,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch projects in learning path
  static Future<ApiResponse<List<Map<String, dynamic>>>> fetchLearnPath({
    required String learningPathId,
  }) async {
    final response =
        await BaseApiClient.get<List<dynamic>>('/learn/$learningPathId');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch user learning IDs
  static Future<ApiResponse<Set<String>>> fetchUserLearningIDs() async {
    final response =
        await BaseApiClient.get<Map<String, dynamic>>('/my/learning');

    if (response.success && response.data != null) {
      final List<dynamic> learningList = response.data!['learning'] ?? [];
      final Set<String> learningIDs = learningList
          .map<String>((item) => item['learning']['IDProject'].toString())
          .toSet();

      return ApiResponse.success(
        data: learningIDs,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Check if user has purchased a project
  static Future<ApiResponse<bool>> hasUserPurchasedProject(
      String projectId) async {
    final response = await fetchUserLearningIDs();

    if (response.success && response.data != null) {
      final bool hasPurchased = response.data!.contains(projectId);
      return ApiResponse.success(
        data: hasPurchased,
        message: 'Project purchase status checked',
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch categories
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchCategories() async {
    final response = await BaseApiClient.get<List<dynamic>>('/categories');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch learning paths
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchLearningPaths() async {
    final response = await BaseApiClient.get<List<dynamic>>('/all/learnpath');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }
}
