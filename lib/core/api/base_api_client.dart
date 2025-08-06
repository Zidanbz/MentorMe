import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mentorme/global/global.dart';

class BaseApiClient {
  static const String baseUrl = 'https://widgets22-catb7yz54a-et.a.run.app/api';
  static const Duration timeout = Duration(seconds: 30);

  static Map<String, String> _getHeaders({String? token}) {
    print('--- DEBUG TOKEN --- : $currentUserToken');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else if (currentUserToken != null) {
      headers['Authorization'] = 'Bearer $currentUserToken';
    }

    return headers;
  }

  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    String? token,
    Map<String, String>? queryParams,
  }) async {
    try {
      Uri uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = _getHeaders(token: token);
      // headers['Content-Type'] = 'application/json'; // <-- [DIHAPUS] Ini adalah perbaikannya

      final response = await http.get(uri, headers: headers).timeout(timeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet');
    } on HttpException {
      return ApiResponse.error('Terjadi kesalahan pada server');
    } on FormatException {
      return ApiResponse.error('Format response tidak valid');
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final headers = _getHeaders(token: token);
      headers['Content-Type'] = 'application/json';

      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet');
    } on HttpException {
      return ApiResponse.error('Terjadi kesalahan pada server');
    } on FormatException {
      return ApiResponse.error('Format response tidak valid');
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final headers = _getHeaders(token: token);
      headers['Content-Type'] = 'application/json';

      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet');
    } on HttpException {
      return ApiResponse.error('Terjadi kesalahan pada server');
    } on FormatException {
      return ApiResponse.error('Format response tidak valid');
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    String? token,
  }) async {
    try {
      final headers = _getHeaders(token: token);
      headers['Content-Type'] = 'application/json';

      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
          )
          .timeout(timeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet');
    } on HttpException {
      return ApiResponse.error('Terjadi kesalahan pada server');
    } on FormatException {
      return ApiResponse.error('Format response tidak valid');
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  static Future<ApiResponse<T>> multipartRequest<T>(
    String endpoint,
    String method, {
    Map<String, String>? fields,
    Map<String, String>? files,
    String? token,
  }) async {
    try {
      final request = http.MultipartRequest(
        method,
        Uri.parse('$baseUrl$endpoint'),
      );

      request.headers.addAll(_getHeaders(token: token));

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (files != null) {
        for (final entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value),
          );
        }
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('Tidak ada koneksi internet');
    } on HttpException {
      return ApiResponse.error('Terjadi kesalahan pada server');
    } on FormatException {
      return ApiResponse.error('Format response tidak valid');
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: $e');
    }
  }

  static ApiResponse<T> _handleResponse<T>(http.Response response) {
    print('--- DEBUG API RESPONSE ---');
    print('Endpoint: ${response.request?.url}');
    print('Status Code: ${response.statusCode}');
    print('Raw Response Body: ${response.body}');
    print('--- AKHIR DEBUG ---');

    try {
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(
          data: data['data'],
          message: data['message'] ?? 'Success',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          data['error'] ?? data['message'] ?? 'Terjadi kesalahan',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Format response tidak valid',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final int? statusCode;

  ApiResponse._({
    required this.success,
    this.data,
    required this.message,
    this.statusCode,
  });

  factory ApiResponse.success({
    T? data,
    required String message,
    int? statusCode,
  }) {
    return ApiResponse._(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String message, {
    int? statusCode,
  }) {
    return ApiResponse._(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
