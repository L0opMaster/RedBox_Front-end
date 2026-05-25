import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Duration timeOut;

  ApiClient({
    required this.baseUrl,
    this.timeOut = const Duration(seconds: 15),
  });

  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _buildHeaders(token);
    final response = await http
        .get(url, headers: headers)
        .timeout(timeOut, onTimeout: () => _timeoutResponse());
    _handleError(response);
    return response;
  }

  // Future<http.Response> post(
  //   String endpoint,
  //   Map<String, String>? body, {
  //   String? token,
  // }) async {
  //   final url = Uri.parse('$baseUrl$endpoint');
  //   final headers = _buildHeaders(token);
  //   final response = await http
  //       .post(url, headers: headers, body: jsonEncode(body))
  //       .timeout(timeOut, onTimeout: () => _timeoutResponse());
  //   _handleError(response);
  //   return response;
  // }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode(body),
    );

    return response;
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  http.Response _timeoutResponse() {
    return http.Response('{"message": "Request time out"}', 408);
  }

  void _handleError(http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Unauthorized: Plaese login again');
    }
    if (response.statusCode >= 500) {
      throw Exception(
        'Server error (${response.statusCode}): ${response.body}',
      );
    }
  }
}
