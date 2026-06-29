import 'package:flutter/material.dart';
import '../../data/models/feedback_model.dart';
import '../../data/services/feedback_service.dart';

class FeedbackProvider extends ChangeNotifier {
  final FeedbackService _service = FeedbackService();

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
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createFeedback({
    required int idAutor,
    required String ruta,
    required int peligro,
    required String comentario,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = FeedbackRequest(
        idAutor: idAutor,
        nombreRuta: ruta,
        nivelPeligro: peligro,
        comentario: comentario,
      );
      
      final newFeedback = await _service.postFeedback(request, token);
      
      _feedbacks.insert(0, newFeedback);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
