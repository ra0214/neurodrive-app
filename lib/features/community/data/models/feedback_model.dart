class FeedbackModel {
  final int id;
  final int idAutor;
  final String nombreRuta;
  final int nivelPeligro;
  final String comentario;
  final String autor;
  final DateTime fecha;

  FeedbackModel({
    required this.id,
    required this.idAutor,
    required this.nombreRuta,
    required this.nivelPeligro,
    required this.comentario,
    required this.autor,
    required this.fecha,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? 0,
      idAutor: json['id_autor'] ?? 0,
      nombreRuta: json['nombre_ruta'] ?? '',
      nivelPeligro: json['nivel_peligro'] ?? 1,
      comentario: json['comentario'] ?? '',
      // Fallback amigable para el autor
      autor: json['autor_nombre'] ?? 'Chofer #${json['id_autor']}', 
      // PARSEO DE FECHA ISO 8601 A HORA LOCAL
      fecha: json['fecha'] != null 
          ? DateTime.parse(json['fecha']).toLocal() 
          : DateTime.now(),
    );
  }
}

class FeedbackResponse {
  final List<FeedbackModel> feedbacks;
  FeedbackResponse({required this.feedbacks});

  factory FeedbackResponse.fromJson(dynamic json) {
    if (json is List) {
      return FeedbackResponse(
        feedbacks: json.map((i) => FeedbackModel.fromJson(i as Map<String, dynamic>)).toList(),
      );
    } else if (json is Map<String, dynamic> && json.containsKey('feedback')) {
      final list = json['feedback'] as List?;
      return FeedbackResponse(
        feedbacks: list?.map((i) => FeedbackModel.fromJson(i as Map<String, dynamic>)).toList() ?? [],
      );
    }
    return FeedbackResponse(feedbacks: []);
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
