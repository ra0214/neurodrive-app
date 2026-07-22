import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'core/security/security_service.dart';
import 'core/providers/global_providers.dart';
import 'features/ai_assistant/presentation/widgets/voice_assistant_bottom_sheet.dart';

// Screens
import 'features/auth/presentation/views/login_screen.dart';
import 'features/auth/presentation/views/register_screen.dart';
import 'features/auth/presentation/views/change_password_screen.dart';
import 'features/profile/presentation/views/profile_screen.dart';
import 'features/ai_assistant/presentation/views/ai_chat_screen.dart';
import 'features/monitoring/presentation/views/fatigue_detection_screen.dart';
import 'features/history/presentation/views/history_screen.dart';
import 'features/community/presentation/views/community_feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecurityService.setupScreenProtection();

  runApp(
    DevicePreview(
      enabled: kIsWeb && !kReleaseMode, 
      builder: (context) => const ProviderScope(
        child: MyApp(),
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
        '/register': (context) => const RegisterScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/home': (context) => const MainContainer(),
        '/profile': (context) => const ProfileScreen(),
        '/ai-assistant': (context) => const AIChatScreen(),
      },
    );
  }
}

class MainContainer extends ConsumerStatefulWidget {
  const MainContainer({super.key});

  @override
  ConsumerState<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends ConsumerState<MainContainer> {
  int _currentIndex = 0;

  void _showVoiceAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceAssistantBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final List<Widget> screens = [
      const FatigueDetectionScreen(),
      const HistoryScreen(),
      const CommunityFeedScreen(),
      const Center(child: Text('Alertas de Ruta')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('NeuroDrive', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      floatingActionButton: FloatingActionButton(
        onPressed: _showVoiceAssistant,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.psychology_outlined, color: Colors.white),
      ),
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
