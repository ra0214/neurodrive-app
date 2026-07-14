enum AlertLevel { normal, warning, critical }

class AlertEntity {
  final String id;
  final String operatorName;
  final DateTime timestamp;
  final AlertLevel level;
  final String title;
  final String description;
  final double fatigueLevel;
  final double closedEyesTime;
  final String? locationName;

  AlertEntity({
    required this.id,
    required this.operatorName,
    required this.timestamp,
    required this.level,
    required this.title,
    required this.description,
    required this.fatigueLevel,
    required this.closedEyesTime,
    this.locationName,
  });
}
