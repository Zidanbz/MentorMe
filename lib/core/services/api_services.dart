import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mentorme/global/global.dart';

class ApiService {
  final String baseUrl = 'https://widgets22-catb7yz54a-et.a.run.app/api';

  // Default headers (gunakan token yang dikirim, jika ada)
  Map<String, String> defaultHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      if ((token ?? currentUserToken) != null)
        'Authorization': 'Bearer ${token ?? currentUserToken}',
    };
  }

  // GET request
  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url, headers: defaultHeaders(token: token));
  }

  // POST request
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: defaultHeaders(token: token),
      body: json.encode(body),
    );
  }

  // PUT request
  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.put(
      url,
      headers: defaultHeaders(token: token),
      body: json.encode(body),
    );
  }

  // DELETE request
  Future<http.Response> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(url, headers: defaultHeaders(token: token));
  }
}
