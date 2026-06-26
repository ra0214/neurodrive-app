import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdatePreferencesUseCase {
  final ProfileRepository repository;

  UpdatePreferencesUseCase(this.repository);

  Future<void> call(NotificationPreferences preferences) {
    return repository.updatePreferences(preferences);
  }
}
