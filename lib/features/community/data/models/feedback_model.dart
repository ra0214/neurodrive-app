class FeedbackModel {
  final int? id;
  final String nombreRuta;
  final int nivelPeligro;
  final String comentario;
  final String autor;
  final DateTime fecha;

  FeedbackModel({
    this.id,
    required this.nombreRuta,
    required this.nivelPeligro,
    required this.comentario,
    required this.autor,
    required this.fecha,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      nombreRuta: json['nombre_ruta'] ?? '',
      nivelPeligro: json['nivel_peligro'] ?? 1,
      comentario: json['comentario'] ?? '',
      autor: json['autor'] ?? 'Compañero Chofer',
      fecha: json['fecha'] != null 
          ? DateTime.parse(json['fecha']) 
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

  // Volvemos a incluir id_autor ya que la API de producción lo requiere obligatoriamente.
  Map<String, dynamic> toJson() => {
        "id_autor": idAutor,
        "nombre_ruta": nombreRuta,
        "nivel_peligro": nivelPeligro,
        "comentario": comentario,
      };
}
