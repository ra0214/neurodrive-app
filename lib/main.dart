import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/monitoring/data/repositories/mock_monitoring_repository.dart';
import 'features/monitoring/presentation/view_models/monitoring_view_model.dart';
import 'features/monitoring/presentation/views/monitoring_screen.dart';
import 'features/history/data/repositories/mock_history_repository.dart';
import 'features/history/presentation/view_models/history_view_models.dart';
import 'features/history/presentation/views/history_screen.dart';
import 'features/community/data/repositories/mock_community_repository.dart';
import 'features/community/presentation/view_models/community_view_model.dart';
import 'features/community/presentation/views/community_screen.dart';
import 'features/profile/data/repositories/mock_profile_repository.dart';
import 'features/profile/domain/use_cases/get_profile_use_case.dart';
import 'features/profile/domain/use_cases/update_preferences_use_case.dart';
import 'features/profile/presentation/view_models/profile_view_model.dart';
import 'features/profile/presentation/views/profile_screen.dart';

void main() {
  // Repositories
  final monitoringRepository = MockMonitoringRepository();
  final historyRepository = MockHistoryRepository();
  final communityRepository = MockCommunityRepository();
  final profileRepository = MockProfileRepository();

  // Use Cases
  final getProfileUseCase = GetProfileUseCase(profileRepository);
  final updatePreferencesUseCase = UpdatePreferencesUseCase(profileRepository);

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MonitoringViewModel(repository: monitoringRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => HistoryViewModel(repository: historyRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => CommunityViewModel(repository: communityRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => ProfileViewModel(
              getProfileUseCase: getProfileUseCase,
              updatePreferencesUseCase: updatePreferencesUseCase,
            ),
          ),
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
      theme: AppTheme.darkTheme,
      home: const MainContainer(),
      routes: {
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
  int _currentIndex = 2; // Default to Community

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      MonitoringScreen(viewModel: context.read<MonitoringViewModel>()),
      HistoryScreen(viewModel: context.read<HistoryViewModel>()),
      CommunityScreen(viewModel: context.read<CommunityViewModel>()),
      const Center(child: Text('Alertas')),
    ];

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text(
          'NeuroDrive',
          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.54),
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
