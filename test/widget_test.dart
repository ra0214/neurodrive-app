import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:neurodrive/main.dart';

// Importaciones de dependencias para los Mocks y ViewModels
import 'package:neurodrive/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:neurodrive/features/auth/domain/use_cases/register_use_case.dart';
import 'package:neurodrive/features/auth/domain/use_cases/login_use_case.dart';
import 'package:neurodrive/features/auth/presentation/view_models/register_view_model.dart';
import 'package:neurodrive/features/auth/presentation/view_models/login_view_model.dart';
import 'package:neurodrive/features/monitoring/data/repositories/mock_monitoring_repository.dart';
import 'package:neurodrive/features/monitoring/presentation/view_models/monitoring_view_model.dart';
import 'package:neurodrive/features/history/data/repositories/mock_history_repository.dart';
import 'package:neurodrive/features/history/presentation/view_models/history_view_models.dart';
import 'package:neurodrive/features/community/data/repositories/mock_community_repository.dart';
import 'package:neurodrive/features/community/presentation/view_models/community_view_model.dart';
import 'package:neurodrive/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:neurodrive/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:neurodrive/features/profile/domain/use_cases/update_preferences_use_case.dart';
import 'package:neurodrive/features/profile/presentation/view_models/profile_view_model.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // 1. Inicializar repositorios mock
    final authRepository = MockAuthRepository();
    final monitoringRepository = MockMonitoringRepository();
    final historyRepository = MockHistoryRepository();
    final communityRepository = MockCommunityRepository();
    final profileRepository = MockProfileRepository();

    // 2. Construir la app con sus Providers (tal como en main.dart)
    // MyApp() no recibe parámetros, los obtiene a través de Provider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RegisterViewModel(registerUseCase: RegisterUseCase(authRepository))),
          ChangeNotifierProvider(create: (_) => LoginViewModel(loginUseCase: LoginUseCase(authRepository))),
          ChangeNotifierProvider(create: (_) => MonitoringViewModel(repository: monitoringRepository)),
          ChangeNotifierProvider(create: (_) => HistoryViewModel(repository: historyRepository)),
          ChangeNotifierProvider(create: (_) => CommunityViewModel(repository: communityRepository)),
          ChangeNotifierProvider(create: (_) => ProfileViewModel(
            getProfileUseCase: GetProfileUseCase(profileRepository),
            updatePreferencesUseCase: UpdatePreferencesUseCase(profileRepository),
          )),
        ],
        child: const MyApp(),
      ),
    );

    // 3. Verificar que la app carga correctamente
    expect(find.byType(MyApp), findsOneWidget);
  });
}
