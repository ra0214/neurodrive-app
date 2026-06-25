abstract class AuthRepository {
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> login({
    required String email,
    required String password,
  });
}
