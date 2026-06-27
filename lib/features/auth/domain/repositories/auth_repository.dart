abstract class AuthRepository {
  Future<void> register({
    required String nombreEmpresa,
    required String rfc,
    required String email,
    required String password,
    String? telefono,
  });

  Future<void> login({
    required String email,
    required String password,
  });
}
