class FatigueInferenceRequest {
  final int idChofer;
  final double blinkDurationMs;
  final double longBlinksPerMin;
  final double perclos1m;
  final double earAvg;
  final double earVariance;
  final double eyelidClosingVel;
  final double eyelidOpeningVel;
  final int microsleepCount;
  final double headPitchAvg;
  final double headPitchVar;
  final double headYawVar;
  final double headRollVar;
  final int headDropRate;
  final double gazePitchVar;
  final double gazeYawVar;
  final double fixationDurationAvg;
  final double saccadeFrequency;
  final double pupilSizeVar;

  FatigueInferenceRequest({
    required this.idChofer,
    required this.blinkDurationMs,
    required this.longBlinksPerMin,
    required this.perclos1m,
    required this.earAvg,
    required this.earVariance,
    required this.eyelidClosingVel,
    required this.eyelidOpeningVel,
    required this.microsleepCount,
    required this.headPitchAvg,
    required this.headPitchVar,
    required this.headYawVar,
    required this.headRollVar,
    required this.headDropRate,
    required this.gazePitchVar,
    required this.gazeYawVar,
    required this.fixationDurationAvg,
    required this.saccadeFrequency,
    required this.pupilSizeVar,
  });

  Map<String, dynamic> toJson() => {
        "id_chofer": idChofer,
        "blink_duration_ms": blinkDurationMs,
        "long_blinks_per_min": longBlinksPerMin,
        "perclos_1m": perclos1m,
        "ear_avg": earAvg,
        "ear_variance": earVariance,
        "eyelid_closing_vel": eyelidClosingVel,
        "eyelid_opening_vel": eyelidOpeningVel,
        "microsleep_count": microsleepCount,
        "head_pitch_avg": headPitchAvg,
        "head_pitch_var": headPitchVar,
        "head_yaw_var": headYawVar,
        "head_roll_var": headRollVar,
        "head_drop_rate": headDropRate,
        "gaze_pitch_var": gazePitchVar,
        "gaze_yaw_var": gazeYawVar,
        "fixation_duration_avg": fixationDurationAvg,
        "saccade_frequency": saccadeFrequency,
        "pupil_size_var": pupilSizeVar,
      };
}

class FatigueInferenceResponse {
  final int idChofer;
  final int assignedCluster;
  final String riskLevel;
  final DateTime timestamp;

  FatigueInferenceResponse({
    required this.idChofer,
    required this.assignedCluster,
    required this.riskLevel,
    required this.timestamp,
  });

  factory FatigueInferenceResponse.fromJson(Map<String, dynamic> json) {
    return FatigueInferenceResponse(
      idChofer: json["id_chofer"] ?? 0,
      assignedCluster: json["assigned_cluster"] ?? 0,
      riskLevel: json["risk_level"] ?? "Desconocido",
      timestamp: DateTime.parse(json["timestamp"] ?? DateTime.now().toIso8601String()),
    );
  }
}
