import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/alert_info.dart';

final alertInfoProvider = Provider<AlertInfo>((ref) {
  return AlertInfo(
    fatigueLevel: 98,
    eyesClosedDuration: 2.4,
    nearestRestArea: 'Centro Comercial La Vaguada',
    distanceToRestArea: 450,
    emergencyContactName: 'Familiar',
    emergencyContactPhone: '+123456789',
  );
});
