enum RecordStatus { critico, optimo, estable }

class DriveRecord {
  final String id;
  final String title;
  final DateTime date;
  final RecordStatus status;

  DriveRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  });
}

class WeeklySummary {
  final int safetyScore;
  final double growthPercentage;
  final List<double> weeklyData;

  WeeklySummary({
    required this.safetyScore,
    required this.growthPercentage,
    required this.weeklyData,
  });
}
