import 'package:flutter/material.dart';
import '../../domain/entities/experience.dart';
import '../../domain/repositories/community_repository.dart';

class CommunityViewModel extends ChangeNotifier {
  final CommunityRepository repository;

  CommunityViewModel({required this.repository});

  List<Experience> _experiences = [];
  List<Experience> get experiences => _experiences;

  CommunitySummary? _summary;
  CommunitySummary? get summary => _summary;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadCommunityData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _experiences = await repository.getExperiences();
      _summary = await repository.getSummary();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
