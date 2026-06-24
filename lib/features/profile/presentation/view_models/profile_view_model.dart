import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository repository;

  UserProfile? _userProfile;
  bool _isLoading = false;

  ProfileViewModel({required this.repository});

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userProfile = await repository.getUserProfile();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleHapticFeedback(bool value) {
    if (_userProfile == null) return;
    _userProfile = UserProfile(
      name: _userProfile!.name,
      id: _userProfile!.id,
      imageUrl: _userProfile!.imageUrl,
      connectedDevice: _userProfile!.connectedDevice,
      emergencyContact: _userProfile!.emergencyContact,
      preferences: _userProfile!.preferences.copyWith(hapticFeedback: value),
    );
    repository.updatePreferences(_userProfile!.preferences);
    notifyListeners();
  }

  void toggleAudioAlerts(bool value) {
    if (_userProfile == null) return;
    _userProfile = UserProfile(
      name: _userProfile!.name,
      id: _userProfile!.id,
      imageUrl: _userProfile!.imageUrl,
      connectedDevice: _userProfile!.connectedDevice,
      emergencyContact: _userProfile!.emergencyContact,
      preferences: _userProfile!.preferences.copyWith(audioAlerts: value),
    );
    repository.updatePreferences(_userProfile!.preferences);
    notifyListeners();
  }

  void toggleAutoNightMode(bool value) {
    if (_userProfile == null) return;
    _userProfile = UserProfile(
      name: _userProfile!.name,
      id: _userProfile!.id,
      imageUrl: _userProfile!.imageUrl,
      connectedDevice: _userProfile!.connectedDevice,
      emergencyContact: _userProfile!.emergencyContact,
      preferences: _userProfile!.preferences.copyWith(autoNightMode: value),
    );
    repository.updatePreferences(_userProfile!.preferences);
    notifyListeners();
  }
}
