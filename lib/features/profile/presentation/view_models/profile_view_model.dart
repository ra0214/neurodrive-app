import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../../domain/use_cases/update_preferences_use_case.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdatePreferencesUseCase updatePreferencesUseCase;

  UserProfile? _userProfile;
  bool _isLoading = false;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.updatePreferencesUseCase,
  });

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userProfile = await getProfileUseCase();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleHapticFeedback(bool value) {
    if (_userProfile == null) return;
    final updatedPreferences = _userProfile!.preferences.copyWith(hapticFeedback: value);
    _updatePreferences(updatedPreferences);
  }

  void toggleAudioAlerts(bool value) {
    if (_userProfile == null) return;
    final updatedPreferences = _userProfile!.preferences.copyWith(audioAlerts: value);
    _updatePreferences(updatedPreferences);
  }

  void toggleAutoNightMode(bool value) {
    if (_userProfile == null) return;
    final updatedPreferences = _userProfile!.preferences.copyWith(autoNightMode: value);
    _updatePreferences(updatedPreferences);
  }

  Future<void> _updatePreferences(NotificationPreferences preferences) async {
    if (_userProfile == null) return;
    
    _userProfile = UserProfile(
      name: _userProfile!.name,
      id: _userProfile!.id,
      imageUrl: _userProfile!.imageUrl,
      connectedDevice: _userProfile!.connectedDevice,
      emergencyContact: _userProfile!.emergencyContact,
      preferences: preferences,
    );
    notifyListeners();

    try {
      await updatePreferencesUseCase(preferences);
    } catch (e) {
      debugPrint('Error updating preferences: $e');
      // Optionally handle rollback if update fails
    }
  }
}
