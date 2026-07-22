class AlertInfo {
  final int fatigueLevel;
  final double eyesClosedDuration;
  final String nearestRestArea;
  final int distanceToRestArea;
  final String emergencyContactName;
  final String emergencyContactPhone;

  AlertInfo({
    required this.fatigueLevel,
    required this.eyesClosedDuration,
    required this.nearestRestArea,
    required this.distanceToRestArea,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
  });
}
