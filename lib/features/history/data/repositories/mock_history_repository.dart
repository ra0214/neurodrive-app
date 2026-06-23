import '../../domain/entities/drive_record.dart';
import '../../domain/repositories/history_repository.dart';

class MockHistoryRepository implements HistoryRepository {
  @override
  Future<List<DriveRecord>> getDriveRecords() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      DriveRecord(
        id: '1',
        title: 'Trayecto al Centro',
        date: DateTime(2023, 8, 24, 18, 42),
        status: RecordStatus.critico,
      ),
      DriveRecord(
        id: '2',
        title: 'Turno de Mañana',
        date: DateTime(2023, 8, 24, 9, 15),
        status: RecordStatus.optimo,
      ),
      DriveRecord(
        id: '3',
        title: 'Ruta de la Costa',
        date: DateTime(2023, 8, 23, 21, 38),
        status: RecordStatus.estable,
      ),
    ];
  }

  @override
  Future<WeeklySummary> getWeeklySummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return WeeklySummary(
      safetyScore: 94,
      growthPercentage: 2.4,
      weeklyData: [0.2, 0.4, 0.8, 0.5, 0.6, 0.3, 0.7],
    );
  }
}
