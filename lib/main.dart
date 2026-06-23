import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';

// Auth Feature
import 'features/auth/data/repositories/mock_auth_repository.dart';
import 'features/auth/domain/use_cases/register_use_case.dart';
import 'features/auth/domain/use_cases/login_use_case.dart';
import 'features/auth/presentation/view_models/register_view_model.dart';
import 'features/auth/presentation/view_models/login_view_model.dart';
import 'features/auth/presentation/views/register_screen.dart';
import 'features/auth/presentation/views/login_screen.dart';

// Other Features
import 'features/monitoring/data/repositories/mock_monitoring_repository.dart';
import 'features/monitoring/presentation/view_models/monitoring_view_model.dart';
import 'features/history/data/repositories/mock_history_repository.dart';
import 'features/history/presentation/view_models/history_view_models.dart';
import 'features/community/data/repositories/mock_community_repository.dart';
import 'features/community/presentation/view_models/community_view_model.dart';

void main() {
  final authRepository = MockAuthRepository();
  final monitoringRepository = MockMonitoringRepository();
  final historyRepository = MockHistoryRepository();
  final communityRepository = MockCommunityRepository();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RegisterViewModel(registerUseCase: RegisterUseCase(authRepository)),
          ),
          ChangeNotifierProvider(
            create: (_) => LoginViewModel(loginUseCase: LoginUseCase(authRepository)),
          ),
          ChangeNotifierProvider(
            create: (_) => MonitoringViewModel(repository: monitoringRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => HistoryViewModel(repository: historyRepository),
          ),
          ChangeNotifierProvider(
            create: (_) => CommunityViewModel(repository: communityRepository),
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
