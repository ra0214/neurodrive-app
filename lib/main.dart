import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'core/security/security_service.dart';

// Auth Feature
import 'features/auth/data/repositories/mock_auth_repository.dart';
import 'features/auth/domain/use_cases/register_use_case.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/presentation/view_models/register_view_model.dart';
import 'features/auth/presentation/view_models/login_view_model.dart';
import 'features/auth/presentation/views/register_screen.dart';
import 'features/auth/presentation/views/login_screen.dart';

// Monitoring & Records
import 'features/monitoring/data/repositories/mock_monitoring_repository.dart';
import 'features/monitoring/presentation/view_models/monitoring_view_model.dart';
import 'features/monitoring/presentation/views/monitoring_screen.dart';
import 'features/history/data/repositories/mock_history_repository.dart';
import 'features/history/presentation/view_models/history_view_models.dart';
import 'features/history/presentation/views/history_screen.dart';
import 'features/community/data/repositories/mock_community_repository.dart';
import 'features/community/presentation/view_models/community_view_model.dart';
import 'features/community/presentation/views/community_screen.dart';

// Profile
import 'features/profile/data/repositories/mock_profile_repository.dart';
import 'features/profile/domain/use_cases/get_profile_use_case.dart';
import 'features/profile/domain/use_cases/update_preferences_use_case.dart';
import 'features/profile/presentation/view_models/profile_view_model.dart';
import 'features/profile/presentation/views/profile_screen.dart';

void main() async {
  // Asegurar que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // PASO 1 SEGURIDAD: Bloqueo de capturas de pantalla y grabaciones
  await SecurityService.setupScreenProtection();

  // Repositories
  final authRepository = MockAuthRepository();
  final monitoringRepository = MockMonitoringRepository();
  final historyRepository = MockHistoryRepository();
  final communityRepository = MockCommunityRepository();
  final profileRepository = MockProfileRepository();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
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
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
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
      MonitoringScreen(viewModel: context.read<MonitoringViewModel>()),
      HistoryScreen(viewModel: context.read<HistoryViewModel>()),
      CommunityScreen(viewModel: context.read<CommunityViewModel>()),
      const Center(child: Text('Alertas')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NeuroDrive',
          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Monitor'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Registros'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Comunidad'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Alerta'),
        ],
      ),
    );
  }
}
