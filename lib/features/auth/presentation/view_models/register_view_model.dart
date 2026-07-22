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
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await registerUseCase.execute(
        fullName: fullName,
        email: email,
        password: password,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
