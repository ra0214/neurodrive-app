import '../../domain/entities/experience.dart';
import '../../domain/repositories/community_repository.dart';

class MockCommunityRepository implements CommunityRepository {
  @override
  Future<List<Experience>> getExperiences() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Experience(
        id: '1',
        userName: 'Carlos M.',
        userRole: 'CONDUCTOR ORO',
        content: '"La vibración de NeuroBand me salvó la vida. Detectó mi somnolencia antes de que yo..."',
        timeAgo: 'hace 2 horas',
        likes: 24,
        comments: 3,
      ),
      Experience(
        id: '2',
        userName: 'Lucía Torres',
        userRole: 'CONDUCTOR VERIFICADO',
        content: '"Excelente app para gestión de flotas. Los datos biométricos son muy precisos."',
        timeAgo: 'hace 5 horas',
        likes: 56,
        comments: 12,
      ),
      Experience(
        id: '3',
        userName: 'Roberto G.',
        userRole: '',
        content: '"NeuroDrive detectó un microsueño de 2 segundos. La vibración me salvó de un accidente seguro."',
        timeAgo: 'hace 1 día',
        likes: 0,
        comments: 0,
        isCritical: true,
      ),
    ];
  }

  @override
  Future<CommunitySummary> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return CommunitySummary(globalPrecision: 98.4);
  }
}
