import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/security/token_storage.dart';
import '../../data/models/feedback_model.dart';
import '../../data/services/feedback_service.dart';

class FeedbackProvider extends ChangeNotifier {
  final FeedbackService _service = FeedbackService();
  final TokenStorage _tokenStorage = TokenStorage();

  List<FeedbackModel> _feedbacks = [];
  List<FeedbackModel> get feedbacks => _feedbacks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFeedbacks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getFeedbacks();
      _feedbacks = response.feedbacks;
    } catch (e) {
      _errorMessage = "Error al cargar el feed: ${e.toString().replaceAll("Exception: ", "")}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createFeedback({
    required String ruta,
    required int peligro,
    required String comentario,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      int? idAutor = await _tokenStorage.getUserId();

      // Si el ID no está en storage, lo extraemos del Token
      if (token != null && idAutor == null) {
        idAutor = _extractUserIdFromToken(token);
        if (idAutor != null) {
          await _tokenStorage.saveUserId(idAutor);
        }
      }

      if (token == null || idAutor == null) {
        _errorMessage = "Sesión incompleta. Por favor inicia sesión nuevamente para vincular tu ID.";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final request = FeedbackRequest(
        idAutor: idAutor,
        nombreRuta: ruta,
        nivelPeligro: peligro,
        comentario: comentario,
      );
      
      await _service.postFeedback(request, token);
      await fetchFeedbacks();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  int? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 0: break;
        case 2: payload += '=='; break;
        case 3: payload += '='; break;
        default: return null;
      }

      final String decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> claims = json.decode(decoded);

      // Búsqueda exhaustiva incluyendo 'chofer_id' que es el campo correcto
      final rawId = claims['chofer_id'] ?? 
                   claims['id_autor'] ?? 
                   claims['id_chofer'] ?? 
                   claims['id'] ?? 
                   claims['user_id'] ?? 
                   claims['uid'] ?? 
                   claims['sub'];
      
      if (rawId is int) return rawId;
      if (rawId is String) return int.tryParse(rawId);
      if (rawId is double) return rawId.toInt();
      
      return null;
    } catch (e) {
      debugPrint("Error decodificando JWT: $e");
      return null;
    }
  }
}
