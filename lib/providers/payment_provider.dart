import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentorme/global/global.dart';

class PaymentProvider {
  static const String baseUrl = 'https://widgets22-catb7yz54a-et.a.run.app';

  /// **1. Get History Transaction**
  Future<Map<String, dynamic>> getHistoryTransaction(String paymentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/profile/history?projectId=$paymentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
            responseData['error'] ?? 'Failed to fetch transaction history');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// **2. Get Pre Payment**
  Future<Map<String, dynamic>> getPraPayment(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/pay/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
            responseData['error'] ?? 'Failed to load payment details');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// **3. Process Payment**
  Future<Map<String, dynamic>?> processPayment(
      String projectId, Map<String, dynamic> paymentData) async {
    final url = Uri.parse('$baseUrl/api/payment/$projectId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
        body: jsonEncode(paymentData),
      );

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      return {'code': 500, 'error': e.toString()};
    }
  }

  /// **4. Get Voucher**
  Future<Map<String, dynamic>> getVoucher() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/voucher/get'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['error'] ?? 'Failed to load vouchers');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// **5. Get Available Vouchers to Claim**
  Future<Map<String, dynamic>> getAvailableVouchersToClaim() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/voucher/available-to-claim'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
            responseData['error'] ?? 'Failed to load available vouchers');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// **6. Claim Voucher**
  Future<Map<String, dynamic>> claimVoucher(String voucherId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/voucher/claim/$voucherId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(responseData['error'] ?? 'Failed to claim voucher');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// **7. Get My Claimed Vouchers**
  Future<Map<String, dynamic>> getMyVouchers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/voucher/my-vouchers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['error'] ?? 'Failed to load my vouchers');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// **8. Get My Available Vouchers for Payment**
  Future<Map<String, dynamic>> getMyAvailableVouchers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/voucher/my-available'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
            responseData['error'] ?? 'Failed to load available vouchers');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  /// **9. Claim Voucher by Code**
  Future<Map<String, dynamic>> claimVoucherByCode(String voucherCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/voucher/claim-by-code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
        body: jsonEncode({'voucherCode': voucherCode}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData['data'],
          'message':
              responseData['data']['message'] ?? 'Voucher claimed successfully'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData['error'] ?? 'Failed to claim voucher'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Failed to connect to server: $e'
      };
    }
  }

  /// **10. Top Up Coin**
  Future<Map<String, dynamic>> topUpCoin(int amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/coin/topUp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
        body: jsonEncode({'amount': amount}),
      );

      final responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      return {'code': 500, 'error': e.toString()};
    }
  }
}
