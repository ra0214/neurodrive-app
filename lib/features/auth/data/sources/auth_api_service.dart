import 'dart:async';
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
  final Duration _timeout = const Duration(seconds: 5);

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": email, "password": password}),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw AuthException("Credenciales inválidas. Verifica tu correo y contraseña.");
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw AuthException(errorData['message'] ?? "Error del servidor (${response.statusCode})");
        } catch (_) {
          throw AuthException("El servicio no está disponible temporalmente (Error ${response.statusCode})");
        }
      }
    } on TimeoutException {
      throw AuthException("El servidor tardó demasiado en responder. Verifica tu conexión.");
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("No se pudo conectar con el servidor. Verifica tu internet.");
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
      ).timeout(_timeout);

      if (response.statusCode != 201) {
        try {
          final errorData = jsonDecode(response.body);
          throw AuthException(errorData['message'] ?? "Error al registrar la cuenta.");
        } catch (_) {
          throw AuthException("Error inesperado en el servidor (${response.statusCode})");
        }
      }
    } on TimeoutException {
      throw AuthException("El servidor tardó demasiado en responder.");
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Error de conexión al registrar.");
    }
  }
}
