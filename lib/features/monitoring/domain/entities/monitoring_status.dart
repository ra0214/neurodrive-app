class MonitoringStatus {
  final int attentionLevel;
  final String activeTime;
  final String sessionId;
  final int heartRate;
  final String blinkFrequency;
  final double cabinTemperature;
  final String nextDestination;

  MonitoringStatus({
    required this.attentionLevel,
    required this.activeTime,
    required this.sessionId,
    required this.heartRate,
    required this.blinkFrequency,
    required this.cabinTemperature,
    required this.nextDestination,
  });
}
