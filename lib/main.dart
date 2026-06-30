import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'core/security/security_service.dart';
import 'core/security/token_storage.dart';

// Auth Feature
import 'features/auth/data/sources/auth_api_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/presentation/view_models/login_view_model.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/auth/presentation/views/change_password_screen.dart';

// Features
import 'features/monitoring/presentation/view_models/monitoring_view_model.dart';
import 'features/monitoring/data/repositories/mock_monitoring_repository.dart';
import 'features/monitoring/presentation/views/fatigue_detection_screen.dart'; // Importada
import 'features/history/data/repositories/mock_history_repository.dart';
import 'features/history/presentation/view_models/history_view_models.dart';
import 'features/history/presentation/views/history_screen.dart';
import 'features/community/presentation/view_models/feedback_provider.dart';
import 'features/community/presentation/views/community_feed_screen.dart';
import 'features/community/presentation/views/community_screen.dart';
import 'features/community/data/repositories/mock_community_repository.dart';
import 'features/community/presentation/view_models/community_view_model.dart';
import 'features/profile/data/repositories/mock_profile_repository.dart';
import 'features/profile/domain/use_cases/get_profile_use_case.dart';
import 'features/profile/domain/use_cases/update_preferences_use_case.dart';
import 'features/profile/presentation/view_models/profile_view_model.dart';
import 'features/profile/presentation/views/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecurityService.setupScreenProtection();

  final authApiService = AuthApiService();
  final tokenStorage = TokenStorage();
  final authRepository = AuthRepositoryImpl(apiService: authApiService, tokenStorage: tokenStorage);

  final monitoringRepository = MockMonitoringRepository();
  final historyRepository = MockHistoryRepository();
  final profileRepository = MockProfileRepository();
  final communityRepository = MockCommunityRepository();

  runApp(
    DevicePreview(
      enabled: kIsWeb && !kReleaseMode, 
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel(loginUseCase: LoginUseCase(authRepository))),
          ChangeNotifierProvider(create: (_) => MonitoringViewModel(repository: monitoringRepository)),
          ChangeNotifierProvider(create: (_) => HistoryViewModel(repository: historyRepository)),
          ChangeNotifierProvider(create: (_) => FeedbackProvider()),
          ChangeNotifierProvider(create: (_) => CommunityViewModel(repository: communityRepository)),
          ChangeNotifierProvider(create: (_) => ProfileViewModel(
            getProfileUseCase: GetProfileUseCase(profileRepository),
            updatePreferencesUseCase: UpdatePreferencesUseCase(profileRepository),
          )),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroDrive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/home': (context) => const MainContainer(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> screens = [
      const FatigueDetectionScreen(), // ACTIVADA: Cámara en tiempo real
      HistoryScreen(viewModel: context.read<HistoryViewModel>()),
      const CommunityFeedScreen(),
      const Center(child: Text('Alertas de Ruta')),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye_outlined), label: 'Monitor'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Comunidad'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Alertas'),
        ],
      ),
    );
  }
}
