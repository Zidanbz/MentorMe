import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mentorme/app/constants/app_constants.dart';
import 'package:mentorme/core/error/app_error.dart';
import 'package:mentorme/core/error/error_handler.dart';
import 'package:mentorme/core/storage/storage_service.dart';

class ApiClient {
  static ApiClient? _instance;
  late final http.Client _client;
  late final SharedPreferencesService _storage;

  ApiClient._() {
    _client = http.Client();
    _initStorage();
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Future<void> _initStorage() async {
    _storage = await SharedPreferencesService.getInstance();
  }

  Future<Map<String, String>> _getHeaders({String? token}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Use provided token or get from storage
    final authToken = token ?? await _storage.getUserToken();
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(token: token);

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(url, headers: headers).timeout(
              const Duration(milliseconds: AppConstants.connectionTimeout));
          break;
        case 'POST':
          response = await _client
              .post(
                url,
                headers: headers,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(
                  const Duration(milliseconds: AppConstants.connectionTimeout));
          break;
        case 'PUT':
          response = await _client
              .put(
                url,
                headers: headers,
                body: body != null ? json.encode(body) : null,
              )
              .timeout(
                  const Duration(milliseconds: AppConstants.connectionTimeout));
          break;
        case 'DELETE':
          response = await _client.delete(url, headers: headers).timeout(
              const Duration(milliseconds: AppConstants.connectionTimeout));
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      return response;
    } on SocketException {
      throw const NetworkError(
        message: 'No internet connection',
        code: 'NO_INTERNET',
      );
    } on HttpException catch (e) {
      throw NetworkError(
        message: e.message,
        code: 'HTTP_EXCEPTION',
        originalError: e,
      );
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  Future<Map<String, dynamic>> _processResponse(http.Response response) async {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return {'success': true};
        }
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ErrorHandler.handleHttpResponse(response);
      }
    } on FormatException {
      throw const ServerError(
        message: 'Invalid response format',
        code: 'INVALID_RESPONSE',
      );
    }
  }

  // Public API methods
  Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    final response = await _makeRequest('GET', endpoint, token: token);
    return await _processResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final response =
        await _makeRequest('POST', endpoint, body: body, token: token);
    return await _processResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final response =
        await _makeRequest('PUT', endpoint, body: body, token: token);
    return await _processResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    final response = await _makeRequest('DELETE', endpoint, token: token);
    return await _processResponse(response);
  }

  void dispose() {
    _client.close();
  }
}
