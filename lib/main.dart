import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
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

void main() {
  final monitoringRepository = MockMonitoringRepository();
  final monitoringViewModel = MonitoringViewModel(repository: monitoringRepository);

  final historyRepository = MockHistoryRepository();
  final historyViewModel = HistoryViewModel(repository: historyRepository);

  final communityRepository = MockCommunityRepository();
  final communityViewModel = CommunityViewModel(repository: communityRepository);

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(
        monitoringViewModel: monitoringViewModel,
        historyViewModel: historyViewModel,
        communityViewModel: communityViewModel,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final MonitoringViewModel monitoringViewModel;
  final HistoryViewModel historyViewModel;
  final CommunityViewModel communityViewModel;

  const MyApp({
    super.key,
    required this.monitoringViewModel,
    required this.historyViewModel,
    required this.communityViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroDrive',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.darkTheme,
      home: MainContainer(
        monitoringViewModel: monitoringViewModel,
        historyViewModel: historyViewModel,
        communityViewModel: communityViewModel,
      ),
    );
  }
}

class MainContainer extends StatefulWidget {
  final MonitoringViewModel monitoringViewModel;
  final HistoryViewModel historyViewModel;
  final CommunityViewModel communityViewModel;

  const MainContainer({
    super.key,
    required this.monitoringViewModel,
    required this.historyViewModel,
    required this.communityViewModel,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 2; // Default to Community as requested

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      MonitoringScreen(viewModel: widget.monitoringViewModel),
      HistoryScreen(viewModel: widget.historyViewModel),
      CommunityScreen(viewModel: widget.communityViewModel),
      const Center(child: Text('Alertas')),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'NeuroDrive',
          style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0E21),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.white54,
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
