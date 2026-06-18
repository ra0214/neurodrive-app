import 'package:flutter/material.dart';
import '../../domain/entities/drive_record.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryRepository repository;

  HistoryViewModel({required this.repository});

  List<DriveRecord> _records = [];
  List<DriveRecord> get records => _records;

  WeeklySummary? _summary;
  WeeklySummary? get summary => _summary;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadHistoryData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _records = await repository.getDriveRecords();
      _summary = await repository.getWeeklySummary();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
