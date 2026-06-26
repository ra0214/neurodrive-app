import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('User Registered: $email');
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Credenciales de prueba (Admin)
    if (email == 'admin@neurodrive.ai' && password == 'admin1234') {
      debugPrint('Admin Login Successful');
      return;
    }
    
    // Por ahora, para facilitar tus pruebas, permitiremos cualquier entrada 
    // pero lanzaremos un error simulado si el correo no tiene formato válido
    if (!email.contains('@')) {
      throw Exception('Correo electrónico no válido');
    }
    
    debugPrint('User Logged In: $email');
  }
}
