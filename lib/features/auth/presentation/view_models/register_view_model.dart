import 'package:flutter/material.dart';
import '../../domain/use_cases/register_use_case.dart';

class RegisterViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;

  RegisterViewModel({required this.registerUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> register({
    required String nombreEmpresa,
    required String rfc,
    required String email,
    required String password,
    String? telefono,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await registerUseCase.execute(
        nombreEmpresa: nombreEmpresa,
        rfc: rfc,
        email: email,
        password: password,
        telefono: telefono,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
