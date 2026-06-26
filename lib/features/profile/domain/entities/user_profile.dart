class UserProfile {
  final String name;
  final String id;
  final String imageUrl;
  final DeviceInfo connectedDevice;
  final EmergencyContact emergencyContact;
  final NotificationPreferences preferences;

  UserProfile({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.connectedDevice,
    required this.emergencyContact,
    required this.preferences,
  });
}

class DeviceInfo {
  final String name;
  final String status;
  final int batteryLevel;

  DeviceInfo({
    required this.name,
    required this.status,
    required this.batteryLevel,
  });
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String phoneNumber;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phoneNumber,
  });
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

  NotificationPreferences copyWith({
    bool? hapticFeedback,
    bool? audioAlerts,
    bool? autoNightMode,
  }) {
    return NotificationPreferences(
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      audioAlerts: audioAlerts ?? this.audioAlerts,
      autoNightMode: autoNightMode ?? this.autoNightMode,
    );
  }
}
