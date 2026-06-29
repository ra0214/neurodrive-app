import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feedback_model.dart';

class FeedbackService {
  final String _baseUrl = "http://173.212.202.138:8080";

  Future<FeedbackResponse> getFeedbacks() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/feedback"));
      
      if (response.statusCode == 200) {
        return FeedbackResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception("Error al obtener reseñas: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }

  Future<FeedbackModel> postFeedback(FeedbackRequest request, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/feedback"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return FeedbackModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 429) {
        throw Exception("Demasiadas peticiones. Intenta más tarde.");
      } else if (response.statusCode == 401) {
        throw Exception("Sesión expirada. Por favor, inicia sesión de nuevo.");
      } else {
        throw Exception("Error al publicar: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
