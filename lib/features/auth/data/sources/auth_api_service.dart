import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class AuthApiService {
  final String baseUrl = "http://173.212.202.138:8080/api/v1";

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/chofer/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception(data["error"] ?? "Licencia o PIN incorrecto");
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
