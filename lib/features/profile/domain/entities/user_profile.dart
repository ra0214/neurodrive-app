class UserProfile {
  final String id;
  final String idEmpresa;
  final String nombre;
  final String apellidos;
  final String numeroLicencia;
  final String telefono;
  final String status; // "activo", "inactivo", "suspendido"
  final String? imageUrl;
  final NotificationPreferences preferences;

  UserProfile({
    required this.id,
    required this.idEmpresa,
    required this.nombre,
    required this.apellidos,
    required this.numeroLicencia,
    required this.telefono,
    required this.status,
    this.imageUrl,
    required this.preferences,
  });

  String get fullName => '$nombre $apellidos';
}

class NotificationPreferences {
  final bool hapticFeedback;
  final bool audioAlerts;
  final bool autoNightMode;

  NotificationPreferences({
    this.hapticFeedback = true,
    this.audioAlerts = true,
    this.autoNightMode = false,
  });
}
