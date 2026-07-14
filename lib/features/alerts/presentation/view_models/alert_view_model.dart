import 'package:flutter/material.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/repositories/alert_repository.dart';

class AlertViewModel extends ChangeNotifier {
  final AlertRepository repository;
  AlertEntity? _currentAlert;

  AlertViewModel({required this.repository}) {
    _listenToAlerts();
  }

  AlertEntity? get currentAlert => _currentAlert;

  void _listenToAlerts() {
    repository.latestCriticalAlert.listen((alert) {
      _currentAlert = alert;
      notifyListeners();
    });
  }

  Future<void> dismissAlert() async {
    if (_currentAlert != null) {
      await repository.dismissAlert(_currentAlert!.id);
      _currentAlert = null;
      notifyListeners();
    }
  }

  void callEmergency() {
    // Aquí iría la lógica para abrir el marcador telefónico
    debugPrint('Llamando a emergencias...');
  }

  void simulateAlert() {
    repository.simulateAlert();
  }
}
