import 'package:flutter/material.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../data/models/auth_models.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginViewModel({required this.loginUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<LoginResponse?> login({
    required String numeroLicencia,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await loginUseCase.execute(
        numeroLicencia: numeroLicencia,
        password: password,
      );
      return response;
    } catch (e) {
      _error = e.toString().replaceAll("Exception: ", "");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
