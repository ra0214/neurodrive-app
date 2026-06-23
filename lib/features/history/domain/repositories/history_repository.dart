import '../entities/drive_record.dart';

abstract class HistoryRepository {
  Future<List<DriveRecord>> getDriveRecords();
  Future<WeeklySummary> getWeeklySummary();
}
