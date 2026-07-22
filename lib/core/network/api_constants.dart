class ApiConstants {
  static const String baseUrl = "http://173.212.202.138:8080/api/v1";
  
  // Auth & Perfil
  static const String login = "/auth/chofer/login";
  static const String profile = "/choferes/me";
  static const String changePassword = "/choferes/password";

  // Telemetría (El corazón de la app)
  static const String inferFatiga = "/analytics/infer";
  static const String logAlertaManual = "/log-alertas";

  // Copiloto (IA Ollama)
  static const String chat = "/chat";
  static const String chatHistory = "/chat/history"; // Requiere /{id_chofer}
  static const String chatPreferences = "/chat/preferences";

  // Familiares (Emergencia)
  static const String familiares = "/familiares";
  static const String familiaresPorChofer = "/familiares/chofer"; // Requiere /{id_chofer}
}
