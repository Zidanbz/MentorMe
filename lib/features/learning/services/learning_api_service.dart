import 'package:mentorme/core/api/base_api_client.dart';

class LearningApiService {
  /// Fetch user learning data
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

  /// Fetch activity progress for a specific project
  static Future<ApiResponse<double>> fetchActivityProgress(
      String idProject) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
        '/my/activity/$idProject');

    if (response.success && response.data != null) {
      final trainList = response.data!['train'];
      if (trainList is List) {
        int total = trainList.length;
        int completed = trainList.where((t) {
          final status = t['trainActivity']?['status'];
          return status == true || status.toString() == 'true';
        }).length;

        double progress = total > 0 ? completed / total : 0.0;
        return ApiResponse.success(
          data: progress,
          message: 'Activity progress calculated',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error('Invalid train data format');
      }
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Fetch activity details
  static Future<ApiResponse<Map<String, dynamic>>> fetchActivityDetails(
      String activityId) async {
    if (activityId.isEmpty) {
      return ApiResponse.error('Invalid activity ID');
    }

    final response = await BaseApiClient.get<Map<String, dynamic>>(
        '/my/activity/$activityId');

    return response;
  }

  /// Check if user has purchased a project
  static Future<ApiResponse<bool>> hasUserPurchasedProject(
      String projectId) async {
    final response = await fetchLearningData();

    if (response.success && response.data != null) {
      for (var learningItem in response.data!) {
        if (learningItem['IDProject'] == projectId) {
          return ApiResponse.success(
            data: true,
            message: 'Project is purchased',
          );
        }
      }
      return ApiResponse.success(
        data: false,
        message: 'Project is not purchased',
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Submit task/assignment
  static Future<ApiResponse<Map<String, dynamic>>> submitTask({
    required String activityId,
    required String filePath,
    required String criticism,
  }) async {
    final response = await BaseApiClient.multipartRequest<Map<String, dynamic>>(
      '/my/activity/$activityId/submit',
      'POST',
      fields: {'criticism': criticism},
      files: {'task': filePath},
    );

    return response;
  }

  /// Get learning progress summary
  static Future<ApiResponse<Map<String, dynamic>>>
      getLearningProgressSummary() async {
    final response =
        await BaseApiClient.get<Map<String, dynamic>>('/my/learning/progress');

    return response;
  }

  /// Mark activity as completed
  static Future<ApiResponse<Map<String, dynamic>>> markActivityCompleted({
    required String activityId,
  }) async {
    final body = {
      'status': 'completed',
    };

    final response = await BaseApiClient.put<Map<String, dynamic>>(
      '/my/activity/$activityId/complete',
      body: body,
    );

    return response;
  }

  /// Get learning certificates
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      getLearningCertificates() async {
    final response = await BaseApiClient.get<List<dynamic>>('/my/certificates');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Download certificate
  static Future<ApiResponse<Map<String, dynamic>>> downloadCertificate({
    required String certificateId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/my/certificates/$certificateId/download',
    );

    return response;
  }

  /// Get learning statistics
  static Future<ApiResponse<Map<String, dynamic>>>
      getLearningStatistics() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
        '/my/learning/statistics');

    return response;
  }

  /// Complete learning process
  static Future<ApiResponse<String>> completeLearning({
    required String learningId,
  }) async {
    final response = await BaseApiClient.post<String>(
      '/learning/$learningId/complete',
      body: {},
    );

    return response;
  }

  /// Rate a completed course
  static Future<ApiResponse<Map<String, dynamic>>> rateCourse({
    required String courseId,
    required int rating,
    String? review,
  }) async {
    final body = {
      'rating': rating,
      if (review != null) 'review': review,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/my/learning/$courseId/rate',
      body: body,
    );

    return response;
  }

  /// Get course materials
  static Future<ApiResponse<List<Map<String, dynamic>>>> getCourseMaterials({
    required String courseId,
  }) async {
    final response = await BaseApiClient.get<List<dynamic>>(
        '/my/learning/$courseId/materials');

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
