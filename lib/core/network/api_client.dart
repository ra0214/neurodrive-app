import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ApiClient {
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<http.Response> post(String endpoint, {Map<String, String>? headers, Object? body}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    final defaultHeaders = {
      'Content-Type': 'application/json',
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    try {
      final response = await _httpClient.post(
        url,
        headers: defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await _httpClient.get(
        url,
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> put(String endpoint, {Map<String, String>? headers, Object? body}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    final defaultHeaders = {
      'Content-Type': 'application/json',
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    try {
      final response = await _httpClient.put(
        url,
        headers: defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await _httpClient.delete(
        url,
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
