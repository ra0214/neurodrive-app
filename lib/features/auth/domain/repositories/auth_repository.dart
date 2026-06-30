import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<LoginResponse> login({
    required String numeroLicencia,
    required String password,
  });
}
