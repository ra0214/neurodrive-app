import '../entities/experience.dart';

abstract class CommunityRepository {
  Future<List<Experience>> getExperiences();
  Future<CommunitySummary> getSummary();
}
