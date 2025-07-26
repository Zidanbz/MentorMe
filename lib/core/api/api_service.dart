import 'package:mentorme/app/constants/app_constants.dart';
import 'package:mentorme/core/api/api_client.dart';
import 'package:mentorme/shared/models/api_response.dart';
import 'package:mentorme/shared/models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final ApiClient _apiClient = ApiClient.instance;

  // Authentication
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConstants.loginEndpoint,
        {
          'email': email,
          'password': password,
          if (fcmToken != null) 'fcmToken': fcmToken,
        },
      );
      return ApiResponse.fromJson(response, null);
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  // Profile
  Future<ApiResponse<UserModel>> getProfile() async {
    try {
      final response = await _apiClient.get(AppConstants.profileEndpoint);
      return ApiResponse.fromJson(
        response,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  // Coin
  Future<ApiResponse<Map<String, dynamic>>> fetchCoin() async {
    try {
      final response = await _apiClient.get(AppConstants.coinEndpoint);
      return ApiResponse.fromJson(response, null);
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  // Learning
  Future<ApiResponse<List<Map<String, dynamic>>>> fetchUserLearning() async {
    try {
      final response = await _apiClient.get(AppConstants.learningEndpoint);
      return ApiResponse.fromJson(
        response,
        (data) => List<Map<String, dynamic>>.from(data['learning'] ?? []),
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  // Categories
  Future<ApiResponse<List<Map<String, dynamic>>>> fetchCategories() async {
    try {
      final response = await _apiClient.get(AppConstants.categoriesEndpoint);
      return ApiResponse.fromJson(
        response,
        (data) => List<Map<String, dynamic>>.from(data),
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  // Learning Paths
  Future<ApiResponse<List<Map<String, dynamic>>>> fetchLearningPaths() async {
    try {
      final response = await _apiClient.get(AppConstants.learnPathEndpoint);
      return ApiResponse.fromJson(
        response,
        (data) => List<Map<String, dynamic>>.from(data),
      );
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }

  // History
  Future<ApiResponse<Map<String, dynamic>>> fetchHistory() async {
    try {
      final response = await _apiClient.get(AppConstants.historyEndpoint);
      return ApiResponse.fromJson(response, null);
    } catch (e) {
      return ApiResponse.error(error: e.toString());
    }
  }
}
