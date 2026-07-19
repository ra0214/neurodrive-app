import '../../domain/entities/user_profile.dart';

class ChoferModel extends UserProfile {
  ChoferModel({
    required super.id,
    required super.idEmpresa,
    required super.nombre,
    required super.apellidos,
    required super.numeroLicencia,
    required super.telefono,
    required super.status,
    super.imageUrl,
    required super.preferences,
  });

  factory ChoferModel.fromJson(Map<String, dynamic> json) {
    return ChoferModel(
      id: json['id'].toString(),
      idEmpresa: json['id_empresa'].toString(),
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      numeroLicencia: json['numero_licencia'] ?? '',
      telefono: json['telefono'] ?? '',
      status: json['status'] ?? 'inactivo',
      imageUrl: json['image_url'],
      preferences: NotificationPreferences(), // Default preferences as they might not come from this specific endpoint
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_empresa': idEmpresa,
      'nombre': nombre,
      'apellidos': apellidos,
      'numero_licencia': numeroLicencia,
      'telefono': telefono,
      'status': status,
      'image_url': imageUrl,
    };
  }
}
