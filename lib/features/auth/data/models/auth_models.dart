class EmpresaModel {
  final int? id;
  final String nombreEmpresa;
  final String rfc;
  final String correo;
  final String? telefono;

  EmpresaModel({
    this.id,
    required this.nombreEmpresa,
    required this.rfc,
    required this.correo,
    this.telefono,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) => EmpresaModel(
        id: json['id'],
        nombreEmpresa: json['nombre_empresa'] ?? '',
        rfc: json['rfc'] ?? '',
        correo: json['correo'] ?? '',
        telefono: json['telefono'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre_empresa': nombreEmpresa,
        'rfc': rfc,
        'correo': correo,
        'telefono': telefono,
      };
}

class AuthResponse {
  final String message;
  final String token;
  final EmpresaModel empresa;

  AuthResponse({
    required this.message,
    required this.token,
    required this.empresa,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      token: json['data']['token'] ?? '',
      empresa: EmpresaModel.fromJson(json['data']['empresa']),
    );
  }
}
