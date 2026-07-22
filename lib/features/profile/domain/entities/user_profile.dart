class UserProfile {
  final int id;
  final int idEmpresa;
  final String name;
  final String apellidos;
  final String numeroLicencia;
  final String telefono;
  final String status;
  final String imageUrl;
  final DeviceInfo connectedDevice;
  final EmergencyContact emergencyContact;
  final NotificationPreferences preferences;

  UserProfile({
    required this.id,
    required this.idEmpresa,
    required this.name,
    required this.apellidos,
    required this.numeroLicencia,
    required this.telefono,
    required this.status,
    required this.imageUrl,
    required this.connectedDevice,
    required this.emergencyContact,
    required this.preferences,
  });

  String get fullName => '$name $apellidos';

  UserProfile copyWith({
    int? id,
    int? idEmpresa,
    String? name,
    String? apellidos,
    String? numeroLicencia,
    String? telefono,
    String? status,
    String? imageUrl,
    DeviceInfo? connectedDevice,
    EmergencyContact? emergencyContact,
    NotificationPreferences? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      name: name ?? this.name,
      apellidos: apellidos ?? this.apellidos,
      numeroLicencia: numeroLicencia ?? this.numeroLicencia,
      telefono: telefono ?? this.telefono,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      connectedDevice: connectedDevice ?? this.connectedDevice,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      preferences: preferences ?? this.preferences,
    );
  }
}

class DeviceInfo {
  final String name;
  final String status;
  final int batteryLevel;
  DeviceInfo({required this.name, required this.status, required this.batteryLevel});
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String phoneNumber;
  EmergencyContact({required this.name, required this.relationship, required this.phoneNumber});
}

class NotificationPreferences {
  final bool hapticFeedback;
  final bool audioAlerts;
  final bool autoNightMode;

  NotificationPreferences({
    required this.hapticFeedback,
    required this.audioAlerts,
    required this.autoNightMode,
  });

  NotificationPreferences copyWith({bool? hapticFeedback, bool? audioAlerts, bool? autoNightMode}) {
    return NotificationPreferences(
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      audioAlerts: audioAlerts ?? this.audioAlerts,
      autoNightMode: autoNightMode ?? this.autoNightMode,
    );
  }
}
