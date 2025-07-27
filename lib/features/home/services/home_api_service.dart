import 'package:mentorme/core/api/base_api_client.dart';

class HomeApiService {
  /// Fetch learning data for home page
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchLearningData() async {
    final response =
        await BaseApiClient.get<Map<String, dynamic>>('/my/learning');

    if (response.success && response.data != null) {
      final List<dynamic> learningList = response.data!['learning'] ?? [];
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(learningList),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch all learning paths
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

  /// Fetch project detail for home
  static Future<ApiResponse<Map<String, dynamic>>> getProjectDetail({
    required String projectId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/learn/project/$projectId',
    );

    return response;
  }

  /// Fetch user profile for home
  static Future<ApiResponse<Map<String, dynamic>>> fetchProfile() async {
    final response =
        await BaseApiClient.get<Map<String, dynamic>>('/profile/get');
    return response;
  }

  /// Fetch user coin balance for home
  static Future<ApiResponse<Map<String, dynamic>>> fetchCoinBalance() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>('/coin/get');
    return response;
  }

  /// Fetch categories for home
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

  /// Fetch featured projects for home
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchFeaturedProjects() async {
    final response =
        await BaseApiClient.get<List<dynamic>>('/project/featured');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch recent activities for home
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchRecentActivities() async {
    final response =
        await BaseApiClient.get<List<dynamic>>('/my/activities/recent');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch learning progress summary for home
  static Future<ApiResponse<Map<String, dynamic>>>
      fetchLearningProgress() async {
    final response =
        await BaseApiClient.get<Map<String, dynamic>>('/my/learning/progress');
    return response;
  }

  /// Fetch notifications for home
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchNotifications() async {
    final response = await BaseApiClient.get<List<dynamic>>('/notif/all');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch recommended projects for home
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchRecommendedProjects() async {
    final response =
        await BaseApiClient.get<List<dynamic>>('/project/recommended');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Search projects from home
  static Future<ApiResponse<List<Map<String, dynamic>>>> searchProjects({
    required String query,
    String? category,
  }) async {
    Map<String, String> queryParams = {'q': query};
    if (category != null) {
      queryParams['category'] = category;
    }

    final response = await BaseApiClient.get<List<dynamic>>(
      '/project/search',
      queryParams: queryParams,
    );

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
