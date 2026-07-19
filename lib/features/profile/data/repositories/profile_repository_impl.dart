import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../services/driver_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DriverService remoteService;

  ProfileRepositoryImpl({required this.remoteService});

  @override
  Future<UserProfile> getUserProfile() async {
    return await remoteService.getProfile();
  }

  @override
  Future<void> updatePreferences(NotificationPreferences preferences) async {
    // Implementar si es necesario, por ahora dejamos el mock o vacío
  }
}
