import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile> getUserProfile() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return UserProfile(
      name: 'Alejandro Vance',
      id: 'ID: ND-8842-TX',
      imageUrl: 'https://i.pravatar.cc/150?u=alejandro', // Placeholder image
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
    // In a real app, this would persist the data
  }
}
