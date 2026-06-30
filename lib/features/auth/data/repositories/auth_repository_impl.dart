import 'dart:convert';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_models.dart';
import '../sources/auth_api_service.dart';
import '../../../../core/security/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.apiService,
    required this.tokenStorage,
  });

  @override
  Future<LoginResponse> login({
    required String numeroLicencia,
    required String password,
  }) async {
    final request = LoginRequest(numeroLicencia: numeroLicencia, password: password);
    final response = await apiService.login(request);
    
    // Guardamos el token
    await tokenStorage.saveToken(response.token);
    
    // Intentamos guardar el ID del chofer
    if (response.idChofer != null) {
      await tokenStorage.saveUserId(response.idChofer!);
    } else {
      // SENIOR FIX: Si el servidor antiguo no manda el ID en el body, lo extraemos del JWT
      final idFromToken = _extractIdFromJwt(response.token);
      if (idFromToken != null) {
        await tokenStorage.saveUserId(idFromToken);
      }
    }
    
    return response;
  }

  int? _extractIdFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) payload += '=';
      
      final payloadJson = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> decoded = json.decode(payloadJson);
      
      // Buscamos id_autor prioritariamente
      final rawId = decoded['id_autor'] ?? decoded['id_chofer'] ?? decoded['id'] ?? decoded['sub'] ?? decoded['user_id'];
      
      if (rawId is num) return rawId.toInt();
      if (rawId is String) return int.tryParse(rawId);
      return null;
    } catch (_) {
      return null;
    }
  }
}
