import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'features/monitoring/data/repositories/mock_monitoring_repository.dart';
import 'features/monitoring/presentation/view_models/monitoring_view_model.dart';
import 'features/monitoring/presentation/views/monitoring_screen.dart';

void main() {
  final monitoringRepository = MockMonitoringRepository();
  final monitoringViewModel = MonitoringViewModel(repository: monitoringRepository);

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(viewModel: monitoringViewModel),
    ),
  );
}

class MyApp extends StatelessWidget {
  final MonitoringViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroDrive',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.darkTheme,
      home: MonitoringScreen(viewModel: viewModel),
    );
  }
}
