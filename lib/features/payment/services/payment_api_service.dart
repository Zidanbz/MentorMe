import 'package:mentorme/core/api/base_api_client.dart';

class PaymentApiService {
  /// Fetch transaction history
  static Future<ApiResponse<Map<String, dynamic>>> fetchTransactionHistory({
    String? projectId,
  }) async {
    String endpoint = '/profile/history';
    Map<String, String>? queryParams;

    if (projectId != null) {
      queryParams = {'projectId': projectId};
    }

    final response = await BaseApiClient.get<Map<String, dynamic>>(
      endpoint,
      queryParams: queryParams,
    );

    return response;
  }

  /// Get payment details for a project
  static Future<ApiResponse<Map<String, dynamic>>> getPaymentDetails({
    required String projectId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/pay/$projectId',
    );

    return response;
  }

  /// Process payment
  static Future<ApiResponse<Map<String, dynamic>>> processPayment({
    required String projectId,
    required String paymentMethod,
    required double amount,
    String? voucherId,
  }) async {
    final body = {
      'projectId': projectId,
      'paymentMethod': paymentMethod,
      'amount': amount,
      if (voucherId != null) 'voucherId': voucherId,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/pay/process',
      body: body,
    );

    return response;
  }

  /// Verify payment status
  static Future<ApiResponse<Map<String, dynamic>>> verifyPaymentStatus({
    required String transactionId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/pay/verify/$transactionId',
    );

    return response;
  }

  /// Get available vouchers
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      getAvailableVouchers() async {
    final response = await BaseApiClient.get<List<dynamic>>('/voucher/get');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Apply voucher
  static Future<ApiResponse<Map<String, dynamic>>> applyVoucher({
    required String voucherId,
    required String projectId,
  }) async {
    final body = {
      'voucherId': voucherId,
      'projectId': projectId,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/voucher/apply',
      body: body,
    );

    return response;
  }

  /// Get payment methods
  static Future<ApiResponse<List<Map<String, dynamic>>>>
      getPaymentMethods() async {
    final response = await BaseApiClient.get<List<dynamic>>('/pay/methods');

    if (response.success && response.data != null) {
      return ApiResponse.success(
        data: List<Map<String, dynamic>>.from(response.data!),
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(response.message, statusCode: response.statusCode);
  }

  /// Cancel payment
  static Future<ApiResponse<Map<String, dynamic>>> cancelPayment({
    required String transactionId,
    String? reason,
  }) async {
    final body = {
      'transactionId': transactionId,
      if (reason != null) 'reason': reason,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/pay/cancel',
      body: body,
    );

    return response;
  }

  /// Request refund
  static Future<ApiResponse<Map<String, dynamic>>> requestRefund({
    required String transactionId,
    required String reason,
  }) async {
    final body = {
      'transactionId': transactionId,
      'reason': reason,
    };

    final response = await BaseApiClient.post<Map<String, dynamic>>(
      '/pay/refund',
      body: body,
    );

    return response;
  }

  /// Get refund status
  static Future<ApiResponse<Map<String, dynamic>>> getRefundStatus({
    required String refundId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/pay/refund/$refundId/status',
    );

    return response;
  }

  /// Upload payment proof
  static Future<ApiResponse<Map<String, dynamic>>> uploadPaymentProof({
    required String transactionId,
    required String imagePath,
  }) async {
    final response = await BaseApiClient.multipartRequest<Map<String, dynamic>>(
      '/pay/upload-proof',
      'POST',
      fields: {'transactionId': transactionId},
      files: {'proof': imagePath},
    );

    return response;
  }

  /// Get payment receipt
  static Future<ApiResponse<Map<String, dynamic>>> getPaymentReceipt({
    required String transactionId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/pay/receipt/$transactionId',
    );

    return response;
  }

  /// Download payment receipt
  static Future<ApiResponse<Map<String, dynamic>>> downloadPaymentReceipt({
    required String transactionId,
  }) async {
    final response = await BaseApiClient.get<Map<String, dynamic>>(
      '/pay/receipt/$transactionId/download',
    );

    return response;
  }
}
