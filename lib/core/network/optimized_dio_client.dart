import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../storage/hive_storage_service.dart';

class OptimizedHttpClient {
  static http.Client? _client;
  static const Duration _timeout = Duration(seconds: 15);
  static const int _maxRetries = 3;

  static http.Client get _httpClient {
    _client ??= http.Client();
    return _client!;
  }

  // Custom Response class
  static Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // GET request with caching and retry
  static Future<OptimizedResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    final uri = _buildUri(url, queryParameters);
    final cacheKey = _generateCacheKey('GET', uri.toString(), null);

    // Check cache first (if not force refresh)
    if (!forceRefresh && cacheDuration != null) {
      final cachedResponse = OptimizedStorageService.getCache<String>(cacheKey);
      if (cachedResponse != null) {
        try {
          final responseData = jsonDecode(cachedResponse);
          if (kDebugMode) {
            print('📦 CACHE HIT: GET $uri');
          }
          return OptimizedResponse(
            statusCode: 200,
            body: cachedResponse,
            data: responseData,
            fromCache: true,
          );
        } catch (e) {
          // Invalid cache, continue with network request
          if (kDebugMode) {
            print('❌ CACHE INVALID: $e');
          }
        }
      }
    }

    // Make network request with retry
    final response = await _makeRequestWithRetry(() async {
      if (kDebugMode) {
        print('🌐 REQUEST: GET $uri');
      }

      final mergedHeaders = {..._defaultHeaders, ...?headers};
      return await _httpClient
          .get(uri, headers: mergedHeaders)
          .timeout(_timeout);
    });

    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} GET $uri');
    }

    final optimizedResponse = OptimizedResponse(
      statusCode: response.statusCode,
      body: response.body,
      data: _tryParseJson(response.body),
      fromCache: false,
    );

    // Cache successful responses
    if (response.statusCode == 200 && cacheDuration != null) {
      await OptimizedStorageService.saveCache(
        cacheKey,
        response.body,
        ttl: cacheDuration,
      );
    }

    return optimizedResponse;
  }

  // POST request with retry
  static Future<OptimizedResponse> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(url, queryParameters);

    final response = await _makeRequestWithRetry(() async {
      if (kDebugMode) {
        print('🌐 REQUEST: POST $uri');
        if (body != null) {
          print('📤 BODY: $body');
        }
      }

      final mergedHeaders = {..._defaultHeaders, ...?headers};
      final encodedBody = body != null ? jsonEncode(body) : null;

      return await _httpClient
          .post(
            uri,
            headers: mergedHeaders,
            body: encodedBody,
          )
          .timeout(_timeout);
    });

    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} POST $uri');
    }

    return OptimizedResponse(
      statusCode: response.statusCode,
      body: response.body,
      data: _tryParseJson(response.body),
      fromCache: false,
    );
  }

  // PUT request with retry
  static Future<OptimizedResponse> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(url, queryParameters);

    final response = await _makeRequestWithRetry(() async {
      if (kDebugMode) {
        print('🌐 REQUEST: PUT $uri');
      }

      final mergedHeaders = {..._defaultHeaders, ...?headers};
      final encodedBody = body != null ? jsonEncode(body) : null;

      return await _httpClient
          .put(
            uri,
            headers: mergedHeaders,
            body: encodedBody,
          )
          .timeout(_timeout);
    });

    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} PUT $uri');
    }

    return OptimizedResponse(
      statusCode: response.statusCode,
      body: response.body,
      data: _tryParseJson(response.body),
      fromCache: false,
    );
  }

  // DELETE request with retry
  static Future<OptimizedResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(url, queryParameters);

    final response = await _makeRequestWithRetry(() async {
      if (kDebugMode) {
        print('🌐 REQUEST: DELETE $uri');
      }

      final mergedHeaders = {..._defaultHeaders, ...?headers};
      return await _httpClient
          .delete(uri, headers: mergedHeaders)
          .timeout(_timeout);
    });

    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} DELETE $uri');
    }

    return OptimizedResponse(
      statusCode: response.statusCode,
      body: response.body,
      data: _tryParseJson(response.body),
      fromCache: false,
    );
  }

  // Helper methods
  static Uri _buildUri(String url, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse(url);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: {
        ...uri.queryParameters,
        ...queryParameters.map((key, value) => MapEntry(key, value.toString())),
      });
    }
    return uri;
  }

  static String _generateCacheKey(
      String method, String url, Map<String, dynamic>? params) {
    final buffer = StringBuffer('${method}_$url');
    if (params != null && params.isNotEmpty) {
      final sortedParams = Map.fromEntries(
          params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      buffer.write('_${jsonEncode(sortedParams)}');
    }
    return buffer.toString();
  }

  static dynamic _tryParseJson(String body) {
    try {
      return jsonDecode(body);
    } catch (e) {
      return body;
    }
  }

  static Future<http.Response> _makeRequestWithRetry(
    Future<http.Response> Function() requestFunction,
  ) async {
    int retryCount = 0;

    while (retryCount < _maxRetries) {
      try {
        return await requestFunction();
      } catch (e) {
        retryCount++;

        if (kDebugMode) {
          print('❌ REQUEST FAILED (attempt $retryCount/$_maxRetries): $e');
        }

        if (retryCount >= _maxRetries || !_shouldRetry(e)) {
          rethrow;
        }

        // Wait before retry with exponential backoff
        await Future.delayed(Duration(seconds: retryCount));
      }
    }

    throw Exception('Max retries exceeded');
  }

  static bool _shouldRetry(dynamic error) {
    return error is SocketException ||
        error is HttpException ||
        error.toString().contains('timeout') ||
        error.toString().contains('connection');
  }

  // Cleanup
  static void dispose() {
    _client?.close();
    _client = null;
  }
}

// Custom Response class
class OptimizedResponse {
  final int statusCode;
  final String body;
  final dynamic data;
  final bool fromCache;

  const OptimizedResponse({
    required this.statusCode,
    required this.body,
    required this.data,
    this.fromCache = false,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  T? getData<T>() => data is T ? data as T : null;
}
