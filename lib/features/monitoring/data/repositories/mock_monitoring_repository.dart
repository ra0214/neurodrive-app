import '../../domain/entities/monitoring_status.dart';
import '../../domain/repositories/monitoring_repository.dart';

class MockMonitoringRepository implements MonitoringRepository {
  @override
  Future<MonitoringStatus> getMonitoringStatus() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MonitoringStatus(
      attentionLevel: 85,
      activeTime: '2h 14m',
      sessionId: '#4921',
      heartRate: 72,
      blinkFrequency: 'Normal',
      cabinTemperature: 22.5,
      nextDestination: 'Valencia Center',
    );
  }
}
