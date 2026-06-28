import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute({
    required String nombreEmpresa,
    required String rfc,
    required String email,
    required String password,
    String? telefono,
  }) {
    return repository.register(
      nombreEmpresa: nombreEmpresa,
      rfc: rfc,
      email: email,
      password: password,
      telefono: telefono,
    );
  }
}
