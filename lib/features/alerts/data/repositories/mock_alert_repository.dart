import 'dart:async';
import '../../domain/entities/alert_entity.dart';
import '../../domain/repositories/alert_repository.dart';

class MockAlertRepository implements AlertRepository {
  final _controller = StreamController<AlertEntity?>.broadcast();

  MockAlertRepository() {
    // Simulamos que llega una alerta después de 5 segundos para probar
    Timer(const Duration(seconds: 10), () {
      _controller.add(AlertEntity(
        id: '1',
        operatorName: 'Juan Pérez',
        timestamp: DateTime.now(),
        level: AlertLevel.critical,
        title: '¡ALERTA CRÍTICA!',
        description: 'MICROSUEÑO DETECTADO',
        fatigueLevel: 98,
        closedEyesTime: 2.4,
        locationName: 'Área de descanso cercana',
      ));
    });
  }

  @override
  Stream<AlertEntity?> get latestCriticalAlert => _controller.stream;

  void simulateAlert() {
    _controller.add(AlertEntity(
      id: 'debug_${DateTime.now().millisecondsSinceEpoch}',
      operatorName: 'Usuario de Prueba',
      timestamp: DateTime.now(),
      level: AlertLevel.critical,
      title: '¡ALERTA CRÍTICA!',
      description: 'MICROSUEÑO DETECTADO',
      fatigueLevel: 98,
      closedEyesTime: 2.4,
      locationName: 'Área de descanso cercana',
    ));
  }

  @override
  Future<void> dismissAlert(String id) async {
    _controller.add(null);
  }
}
