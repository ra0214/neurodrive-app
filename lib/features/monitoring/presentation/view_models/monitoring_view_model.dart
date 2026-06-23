import 'package:flutter/material.dart';
import '../../domain/entities/monitoring_status.dart';
import '../../domain/repositories/monitoring_repository.dart';

class MonitoringViewModel extends ChangeNotifier {
  final MonitoringRepository repository;

  MonitoringViewModel({required this.repository});

  MonitoringStatus? _status;
  MonitoringStatus? get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadMonitoringData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _status = await repository.getMonitoringStatus();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
