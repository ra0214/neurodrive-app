import 'dart:convert';

class LoginRequest {
  final String numeroLicencia;
  final String password;

  LoginRequest({required this.numeroLicencia, required this.password});

  Map<String, dynamic> toJson() => {
        "numero_licencia": numeroLicencia,
        "password": password,
      };
}

class LoginResponse {
  final String message;
  final String token;
  final bool requiereCambioPassword;
  final int? idChofer;

  LoginResponse({
    required this.message,
    required this.token,
    required this.requiereCambioPassword,
    this.idChofer,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final String token = json["token"] ?? json["jwt"] ?? json["access_token"] ?? "";
    
    final dynamic rawId = json["chofer_id"] ??
                         json["id_autor"] ?? 
                         json["id_chofer"] ?? 
                         json["id"] ?? 
                         json["user_id"];
                         
    int? extractedId;
    if (rawId is num) {
      extractedId = rawId.toInt();
    } else if (rawId is String) {
      extractedId = int.tryParse(rawId);
    }

    // Fallback: Extraer del JWT si no vino en el JSON plano
    if (extractedId == null && token.isNotEmpty) {
      extractedId = _extractIdFromJwt(token);
    }
    
    return LoginResponse(
      message: json["message"] ?? "",
      token: token,
      requiereCambioPassword: json["requiere_cambio_password"] ?? false,
      idChofer: extractedId,
    );
  }

  static int? _extractIdFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) payload += '=';
      final payloadJson = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> decoded = json.decode(payloadJson);
      
      // También buscamos chofer_id dentro del token
      final id = decoded['chofer_id'] ?? 
                 decoded['id_autor'] ?? 
                 decoded['id_chofer'] ?? 
                 decoded['id'] ?? 
                 decoded['sub'];

      if (id is num) return id.toInt();
      return int.tryParse(id.toString());
    } catch (_) {
      return null;
    }
  }
}
