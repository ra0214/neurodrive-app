import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/security/token_storage.dart';

class ProfileApiService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  ProfileApiService(this._apiClient, this._tokenStorage);

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _tokenStorage.getToken();
    
    final response = await _apiClient.get(
      ApiConstants.profile,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener el perfil: ${response.statusCode}');
    }
  }

  // Aquí iría el updatePreferences si el backend lo soporta
}
