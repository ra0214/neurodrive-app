import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feedback_model.dart';

class FeedbackService {
  final String _baseUrl = "http://173.212.202.138:8080";

  Future<FeedbackResponse> getFeedbacks() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/feedback"));
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return FeedbackResponse.fromJson(decoded);
      } else {
        throw Exception("Error del servidor (${response.statusCode})");
      }
    } catch (e) {
      throw Exception("No se pudo cargar el feed: $e");
    }
  }

  Future<void> postFeedback(FeedbackRequest request, String token) async {
    try {
      // REGLA DE COMPATIBILIDAD (PRODUCCIÓN): 
      // Incluimos id_autor explícitamente como requiere la API antigua.
      final Map<String, dynamic> bodyMap = request.toJson();
      final String jsonString = json.encode(bodyMap);
      
      // DEBUG para el desarrollador
      print(">>> ENVIANDO FEEDBACK A PRODUCCIÓN");
      print(">>> JSON: $jsonString");

      final List<int> bodyBytes = utf8.encode(jsonString);

      final response = await http.post(
        Uri.parse("$_baseUrl/feedback"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: bodyBytes,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception("Tu sesión ha expirado. Por favor ingresa de nuevo.");
      } else if (response.statusCode == 400) {
        final decoded = json.decode(response.body);
        final String detail = decoded['error'] ?? decoded['message'] ?? "Datos de entrada inválidos (400)";
        throw Exception(detail);
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
