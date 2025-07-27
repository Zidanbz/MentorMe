import 'package:mentorme/core/api/base_api_client.dart';

class ConsultationApiService {
  /// Fetch all chat rooms
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      fetchChatRooms() async {
    final response = await BaseApiClient.get<List<dynamic>>('/chat');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Create a new chat room
  static Future<ApiResponse<Map<String, dynamic>>> createChatRoom({
    required String mentorEmail,
    required String subject,
    String? initialMessage,
  }) async {
    final body = {
      'mentorEmail': mentorEmail,
      'subject': subject,
      if (initialMessage != null) 'initialMessage': initialMessage,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/chat',
      body: body,
    );

    return response;
  }

  /// Get chat room details
  static Future<ApiResponse<Map<String, dynamic>>> getChatRoomDetails({
    required String roomId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/chat/$roomId',
    );

    return response;
  }

  /// Send message in chat room
  static Future<ApiResponse<Map<String, dynamic>>> sendMessage({
    required String roomId,
    required String message,
    String? messageType,
  }) async {
    final body = {
      'message': message,
      'messageType': messageType ?? 'text',
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/chat/$roomId/message',
      body: body,
    );

    return response;
  }

  /// Get chat history
  static Future<ApiResponse<List<Map<String, dynamic>>>> getChatHistory({
    required String roomId,
    int? limit,
    int? offset,
  }) async {
    Map<String, String>? queryParams;

    if (limit != null || offset != null) {
      queryParams = {};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
    }

    final response = await BaseApiClient.get<List<dynamic>>(
      '/chat/$roomId/history',
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

  /// Mark messages as read
  static Future<ApiResponse<Map<String, dynamic>>> markMessagesAsRead({
    required String roomId,
    required List<String> messageIds,
  }) async {
    final body = {
      'messageIds': messageIds,
    };

    final response = await BaseApiClient.put<Map<String, dynamic>>(
      '/chat/$roomId/read',
      body: body,
    );

    return response;
  }

  /// Upload file/image in chat
  static Future<ApiResponse<Map<String, dynamic>>> uploadChatFile({
    required String roomId,
    required String filePath,
    String? caption,
  }) async {
    Map<String, String>? fields;
    if (caption != null) {
      fields = {'caption': caption};
    }

    final response = await BaseApiClient.multipartRequest<Map<String, dynamic>>(
      '/chat/$roomId/upload',
      'POST',
      fields: fields,
      files: {'file': filePath},
    );

    return response;
  }

  /// Get available mentors
  static Future<ApiResponse<List<Map<String, dynamic>>>> getAvailableMentors({
    String? category,
    String? expertise,
  }) async {
    Map<String, String>? queryParams;

    if (category != null || expertise != null) {
      queryParams = {};
      if (category != null) queryParams['category'] = category;
      if (expertise != null) queryParams['expertise'] = expertise;
    }

    final response = await BaseApiClient.get<List<dynamic>>(
      '/mentors/available',
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

  /// Get mentor details
  static Future<ApiResponse<Map<String, dynamic>>> getMentorDetails({
    required String mentorId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/mentors/$mentorId',
    );

    return response;
  }

  /// Rate consultation session
  static Future<ApiResponse<Map<String, dynamic>>> rateConsultation({
    required String roomId,
    required int rating,
    String? feedback,
  }) async {
    final body = {
      'rating': rating,
      if (feedback != null) 'feedback': feedback,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/chat/$roomId/rate',
      body: body,
    );

    return response;
  }

  /// End consultation session
  static Future<ApiResponse<Map<String, dynamic>>> endConsultation({
    required String roomId,
  }) async {
    final response = await BaseApiClient.put<Map<String, dynamic>>(
      '/chat/$roomId/end',
    );

    return response;
  }

  /// Get consultation statistics
  static Future<ApiResponse<Map<String, dynamic>>>
      getConsultationStatistics() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/consultation/statistics',
    );

    return response;
  }

  /// Schedule consultation
  static Future<ApiResponse<Map<String, dynamic>>> scheduleConsultation({
    required String mentorId,
    required DateTime scheduledTime,
    required String topic,
    String? description,
  }) async {
    final body = {
      'mentorId': mentorId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'topic': topic,
      if (description != null) 'description': description,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/consultation/schedule',
      body: body,
    );

    return response;
  }

  /// Get scheduled consultations
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      getScheduledConsultations() async {
    final response = await BaseApiClient.get<List<dynamic>>(
      '/consultation/scheduled',
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

  /// Update last sender in a chat room
  static Future<ApiResponse<Map<String, dynamic>>> updateLastSender({
    required int roomId,
    required String lastSender,
  }) async {
    final body = {
      'idRoom': roomId,
      'lastSender': lastSender,
    };

    final response = await BaseApiClient.put<Map<String, dynamic>>(
      '/chat/lastsender',
      body: body,
    );

    return response;
  }
}
