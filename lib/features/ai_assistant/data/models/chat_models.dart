class ChatRequest {
  final int idChofer;
  final String message;

  ChatRequest({required this.idChofer, required this.message});

  Map<String, dynamic> toJson() => {
        "id_chofer": idChofer,
        "message": message,
      };
}

class ChatResponse {
  final String message;
  final String action;
  final String? data;

  ChatResponse({required this.message, required this.action, this.data});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json["message"] ?? "",
      action: json["action"] ?? "NONE",
      data: json["data"],
    );
  }
}

class ChatPreferenceRequest {
  final int idChofer;
  final List<String> topics;

  ChatPreferenceRequest({required this.idChofer, required this.topics});

  Map<String, dynamic> toJson() => {
        "id_chofer": idChofer,
        "topics": topics,
      };
}

class ChatHistoryMessage {
  final String role;
  final String content;

  ChatHistoryMessage({required this.role, required this.content});

  factory ChatHistoryMessage.fromJson(Map<String, dynamic> json) {
    return ChatHistoryMessage(
      role: json["role"] ?? "",
      content: json["content"] ?? "",
    );
  }
}
