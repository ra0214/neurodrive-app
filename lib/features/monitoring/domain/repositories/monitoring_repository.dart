import '../entities/monitoring_status.dart';

abstract class MonitoringRepository {
  Future<MonitoringStatus> getMonitoringStatus();
}
