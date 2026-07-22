import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile> getUserProfile() async {
    // Simulando retraso de red
    await Future.delayed(const Duration(milliseconds: 500));
    return UserProfile(
      id: 1,
      idEmpresa: 101,
      name: 'Alejandro',
      apellidos: 'Vance',
      numeroLicencia: 'ND-8842-TX',
      telefono: '+34 612 345 678',
      status: 'activo',
      imageUrl: 'https://i.pravatar.cc/150?u=alejandro', 
      connectedDevice: DeviceInfo(
        name: 'NeuroBand Gen-3',
        status: 'Conectado',
        batteryLevel: 88,
      ),
      emergencyContact: EmergencyContact(
        name: 'Elena Vance',
        relationship: 'Esposa',
        phoneNumber: '+34 612 345 678',
      ),
      preferences: NotificationPreferences(
        hapticFeedback: true,
        audioAlerts: true,
        autoNightMode: false,
      ),
    );
  }

  @override
  Future<void> updatePreferences(NotificationPreferences preferences) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
