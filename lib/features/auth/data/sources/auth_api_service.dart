import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class AuthApiService {
  final String baseUrl = "http://173.212.202.138:8080/api/v1";

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw AuthException("Credenciales inválidas. Verifica tu correo y contraseña.");
      } else {
        final errorData = jsonDecode(response.body);
        throw AuthException(errorData['message'] ?? "Error del servidor (${response.statusCode})");
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Error de conexión. Verifica tu internet.");
    }
  }

  Future<void> register({
    required String nombreEmpresa,
    required String rfc,
    required String email,
    required String password,
    String? telefono,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre_empresa": nombreEmpresa,
          "rfc": rfc,
          "correo": email,
          "password": password,
          "telefono": telefono ?? "",
        }),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw AuthException(errorData['message'] ?? "Error al registrar la cuenta.");
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Error de conexión. Verifica tu internet.");
    }
  }
}
