import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/auth_models.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        body: request.toJson(),
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
