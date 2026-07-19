import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserProfile(
      id: 'ND-8842-TX',
      idEmpresa: 'EMP-2024-001',
      nombre: 'Alejandro',
      apellidos: 'Vance',
      numeroLicencia: 'LIC-773322-MEX',
      telefono: '+52 55 1234 5678',
      status: 'activo',
      imageUrl: 'https://i.pravatar.cc/150?u=alejandro',
      preferences: NotificationPreferences(),
    );
  }

  @override
  Future<void> updatePreferences(NotificationPreferences preferences) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
