import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../security/token_storage.dart';

// Features - Auth
import '../../features/auth/data/sources/auth_api_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/register_use_case.dart';
import '../../features/auth/presentation/view_models/login_view_model.dart';
import '../../features/auth/presentation/view_models/register_view_model.dart';

// Features - Profile
import '../../features/profile/data/sources/profile_api_service.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/use_cases/get_profile_use_case.dart';
import '../../features/profile/domain/use_cases/update_preferences_use_case.dart';
import '../../features/profile/presentation/view_models/profile_view_model.dart';

// Features - Monitoring & IA
import '../../features/monitoring/presentation/view_models/fatigue_controller.dart';
import '../../features/monitoring/data/repositories/mock_monitoring_repository.dart';
import '../../features/monitoring/presentation/view_models/monitoring_view_model.dart';
import '../../features/monitoring/data/sources/monitoring_api_service.dart';

// Features - History
import '../../features/history/data/repositories/mock_history_repository.dart';
import '../../features/history/presentation/view_models/history_view_models.dart';

// Features - Community
import '../../features/community/data/repositories/mock_community_repository.dart';
import '../../features/community/presentation/view_models/community_view_model.dart';
import '../../features/community/presentation/view_models/feedback_provider.dart';

// Features - AI Assistant
import '../../features/ai_assistant/data/sources/chat_api_service.dart';
import '../../features/ai_assistant/presentation/view_models/chat_view_model.dart';
import '../../features/ai_assistant/presentation/view_models/voice_assistant_view_model.dart';

// --- PROVIDERS GLOBALES ---

final apiClientProvider = Provider((ref) => ApiClient());
final tokenStorageProvider = Provider((ref) => TokenStorage());

// Auth
final authApiServiceProvider = Provider((ref) => AuthApiService(ref.watch(apiClientProvider)));
final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(
  apiService: ref.watch(authApiServiceProvider),
  tokenStorage: ref.watch(tokenStorageProvider),
));
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.watch(authRepositoryProvider)));
final registerUseCaseProvider = Provider((ref) => RegisterUseCase(ref.watch(authRepositoryProvider)));

final loginViewModelProvider = ChangeNotifierProvider((ref) => LoginViewModel(
  loginUseCase: ref.watch(loginUseCaseProvider),
));
final registerViewModelProvider = ChangeNotifierProvider((ref) => RegisterViewModel(
  registerUseCase: ref.watch(registerUseCaseProvider),
));

// Profile
final profileApiServiceProvider = Provider((ref) => ProfileApiService(
  ref.watch(apiClientProvider),
  ref.watch(tokenStorageProvider),
));
final profileRepositoryProvider = Provider((ref) => ProfileRepositoryImpl(
  apiService: ref.watch(profileApiServiceProvider),
));
final getProfileUseCaseProvider = Provider((ref) => GetProfileUseCase(ref.watch(profileRepositoryProvider)));
final updatePreferencesUseCaseProvider = Provider((ref) => UpdatePreferencesUseCase(ref.watch(profileRepositoryProvider)));

final profileViewModelProvider = ChangeNotifierProvider((ref) => ProfileViewModel(
  getProfileUseCase: ref.watch(getProfileUseCaseProvider),
  updatePreferencesUseCase: ref.watch(updatePreferencesUseCaseProvider),
));

// Monitoring & IA
final monitoringApiServiceProvider = Provider((ref) => MonitoringApiService(
  ref.watch(apiClientProvider),
  ref.watch(tokenStorageProvider),
));

final fatigueControllerProvider = ChangeNotifierProvider((ref) {
  final apiService = ref.watch(monitoringApiServiceProvider);
  return FatigueController(apiService);
});

final monitoringRepositoryProvider = Provider((ref) => MockMonitoringRepository());
final monitoringViewModelProvider = ChangeNotifierProvider((ref) => MonitoringViewModel(
  repository: ref.watch(monitoringRepositoryProvider),
));

// History
final historyRepositoryProvider = Provider((ref) => MockHistoryRepository());
final historyViewModelProvider = ChangeNotifierProvider((ref) => HistoryViewModel(
  repository: ref.watch(historyRepositoryProvider),
));

// Community
final communityRepositoryProvider = Provider((ref) => MockCommunityRepository());
final communityViewModelProvider = ChangeNotifierProvider((ref) => CommunityViewModel(
  repository: ref.watch(communityRepositoryProvider),
));
final feedbackProvider = ChangeNotifierProvider((ref) => FeedbackProvider());

// Chat / Copiloto
final chatApiServiceProvider = Provider((ref) => ChatApiService(
  ref.watch(apiClientProvider),
  ref.watch(tokenStorageProvider),
));

final chatViewModelProvider = ChangeNotifierProvider((ref) => ChatViewModel(
  ref.watch(chatApiServiceProvider),
));

final voiceAssistantViewModelProvider = ChangeNotifierProvider((ref) => VoiceAssistantViewModel(
  ref.watch(chatApiServiceProvider),
));
