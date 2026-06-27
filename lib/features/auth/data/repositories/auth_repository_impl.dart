import '../../domain/repositories/auth_repository.dart';
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
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await apiService.login(email, password);
    await tokenStorage.saveToken(response.token);
  }

  @override
  Future<void> register({
    required String nombreEmpresa,
    required String rfc,
    required String email,
    required String password,
    String? telefono,
  }) async {
    await apiService.register(
      nombreEmpresa: nombreEmpresa,
      rfc: rfc,
      email: email,
      password: password,
      telefono: telefono,
    );
  }
}
