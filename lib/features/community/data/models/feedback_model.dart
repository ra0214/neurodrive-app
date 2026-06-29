class FeedbackModel {
  final int id;
  final int idAutor;
  final String nombreRuta;
  final int nivelPeligro;
  final String comentario;
  final DateTime fecha;

  FeedbackModel({
    required this.id,
    required this.idAutor,
    required this.nombreRuta,
    required this.nivelPeligro,
    required this.comentario,
    required this.fecha,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? 0,
      idAutor: json['id_autor'] ?? 0,
      nombreRuta: json['nombre_ruta'] ?? '',
      nivelPeligro: json['nivel_peligro'] ?? 1,
      comentario: json['comentario'] ?? '',
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class FeedbackResponse {
  final List<FeedbackModel> feedbacks;
  final int total;

  FeedbackResponse({required this.feedbacks, required this.total});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      feedbacks: (json['feedback'] as List)
          .map((i) => FeedbackModel.fromJson(i))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}

class FeedbackRequest {
  final int idAutor;
  final String nombreRuta;
  final int nivelPeligro;
  final String comentario;

  FeedbackRequest({
    required this.idAutor,
    required this.nombreRuta,
    required this.nivelPeligro,
    required this.comentario,
  });

  Map<String, dynamic> toJson() => {
        "id_autor": idAutor,
        "nombre_ruta": nombreRuta,
        "nivel_peligro": nivelPeligro,
        "comentario": comentario,
      };
}
