import '../entities/alert_entity.dart';

abstract class AlertRepository {
  Stream<AlertEntity?> get latestCriticalAlert;
  Future<void> dismissAlert(String id);
  void simulateAlert(); // Añadido para pruebas
}
