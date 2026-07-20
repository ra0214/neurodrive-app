import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';

class AssistantViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    // Simulate AI response
    _simulateAiResponse();
  }

  Future<void> _simulateAiResponse() async {
    _isTyping = true;
    notifyListeners();

    // Mock delay
    await Future.delayed(const Duration(seconds: 2));

    _messages.add(ChatMessage(
      text: "Hola, soy el asistente de NeuroDrive. ¿En qué puedo ayudarte hoy?",
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
    ));

    _isTyping = false;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
