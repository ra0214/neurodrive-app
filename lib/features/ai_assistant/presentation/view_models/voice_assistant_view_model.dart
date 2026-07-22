import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/chat_models.dart';
import '../../data/sources/chat_api_service.dart';
import '../../../../core/security/token_storage.dart';

class VoiceAssistantViewModel extends ChangeNotifier {
  final ChatApiService _apiService;
  final TokenStorage _tokenStorage = TokenStorage();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  VoiceAssistantViewModel(this._apiService) {
    _initTts();
  }

  bool _isListening = false;
  bool get isListening => _isListening;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  String _lastWords = "Presiona el botón para hablar";
  String get lastWords => _lastWords;

  void _initTts() async {
    await _tts.setLanguage("es-ES");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('STT Status: $status'),
      onError: (errorNotification) => debugPrint('STT Error: $errorNotification'),
    );

    if (available) {
      _isListening = true;
      _lastWords = "Escuchando...";
      notifyListeners();

      _speech.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          if (result.finalResult) {
            _isListening = false;
            _processVoiceCommand(_lastWords);
          }
          notifyListeners();
        },
        localeId: "es_ES",
      );
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }

  Future<void> _processVoiceCommand(String text) async {
    if (text.isEmpty) return;

    _isProcessing = true;
    notifyListeners();

    try {
      final idChofer = await _tokenStorage.getUserId();
      if (idChofer == null) throw Exception("No se encontró el ID del chofer");

      final request = ChatRequest(idChofer: idChofer, message: text);
      final response = await _apiService.sendMessage(request);

      // 1. Hablar la respuesta
      await _tts.speak(response.message);
      _lastWords = response.message;

      // 2. Ejecutar Acciones (Ej: Spotify)
      if (response.action == "OPEN_SPOTIFY" && response.data != null) {
        final Uri url = Uri.parse(response.data!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("No se pudo abrir la URL de Spotify: ${response.data}");
        }
      }
    } catch (e) {
      _lastWords = "Error: Lo siento, no pude procesar tu comando.";
      debugPrint("Error en asistente de voz: $e");
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
