import 'package:mentorme/core/api/base_api_client.dart';

class TopupApiService {
  /// Get coin balance
  static Future<ApiResponse<Map<String, dynamic>>> getCoinBalance() async {
    final response = await BaseApiClient.get<Map<String, dynamic>>('/coin/get');
    return response;
  }

  /// Top up coins
  static Future<ApiResponse<Map<String, dynamic>>> topUpCoins({
    required double amount,
    required String paymentMethod,
    String? promoCode,
  }) async {
    final body = {
      'amount': amount,
      'paymentMethod': paymentMethod,
      if (promoCode != null) 'promoCode': promoCode,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/coin/topUp',
      body: body,
    );
    return response;
  }

  /// Get top up history
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      getTopUpHistory() async {
    final response = await BaseApiClient.get<List<dynamic>>('/coin/history');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Get available top up packages
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      getTopUpPackages() async {
    final response = await BaseApiClient.get<List<dynamic>>('/coin/packages');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Verify top up payment
  static Future<ApiResponse<Map<String, dynamic>>> verifyPayment({
    required String transactionId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/coin/verify/$transactionId',
    );
    return response;
  }

  /// Apply promo code for top up
  static Future<ApiResponse<Map<String, dynamic>>> applyPromo({
    required String promoCode,
    required double amount,
  }) async {
    final body = {
      'promoCode': promoCode,
      'amount': amount,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/coin/promo/apply',
      body: body,
    );
    return response;
  }

  /// Cancel top up transaction
  static Future<ApiResponse<Map<String, dynamic>>> cancelTopUp({
    required String transactionId,
    String? reason,
  }) async {
    final body = {
      'transactionId': transactionId,
      if (reason != null) 'reason': reason,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/coin/cancel',
      body: body,
    );
    return response;
  }

  /// Get coin usage statistics
  static Future<ApiResponse<Map<String, dynamic>>> getCoinStatistics() async {
    final response =
        await BaseApiClient.get<Map<String, dynamic>>('/coin/statistics');
    return response;
  }
}
