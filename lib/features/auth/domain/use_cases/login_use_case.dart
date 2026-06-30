import '../repositories/auth_repository.dart';
import '../../data/models/auth_models.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponse> execute({
    required String numeroLicencia,
    required String password,
  }) {
    return repository.login(
      numeroLicencia: numeroLicencia,
      password: password,
    );
  }
}
