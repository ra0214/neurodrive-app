import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../../domain/use_cases/update_preferences_use_case.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdatePreferencesUseCase updatePreferencesUseCase;

  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _unauthorized = false;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.updatePreferencesUseCase,
  });

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get unauthorized => _unauthorized;

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    _unauthorized = false;
    notifyListeners();

    try {
      _userProfile = await getProfileUseCase();
    } catch (e) {
      _errorMessage = e.toString();
      if (e.toString().contains('Unauthorized')) {
        _unauthorized = true;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Se puede implementar la lógica de actualización de preferencias aquí si es necesario
  Future<void> updatePreferences(NotificationPreferences prefs) async {
    try {
      await updatePreferencesUseCase(prefs);
      if (_userProfile != null) {
        // En un caso real, aquí actualizaríamos el estado local
        loadProfile(); 
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
