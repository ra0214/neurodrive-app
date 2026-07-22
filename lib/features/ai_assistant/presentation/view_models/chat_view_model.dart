import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/chat_models.dart';
import '../../data/sources/chat_api_service.dart';
import '../../../../core/security/token_storage.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatApiService _apiService;
  final TokenStorage _tokenStorage = TokenStorage();

  ChatViewModel(this._apiService);

  List<ChatHistoryMessage> _messages = [];
  List<ChatHistoryMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final idChofer = await _tokenStorage.getUserId();
      if (idChofer != null) {
        _messages = await _apiService.getHistory(idChofer);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    final idChofer = await _tokenStorage.getUserId();
    if (idChofer == null) return;

    final userMsg = ChatHistoryMessage(role: 'user', content: text);
    _messages.add(userMsg);
    _isLoading = true;
    notifyListeners();

    try {
      final request = ChatRequest(idChofer: idChofer, message: text);
      final response = await _apiService.sendMessage(request);
      
      _messages.add(ChatHistoryMessage(role: 'assistant', content: response.message));
      
      // PROCESAR ACCIONES DE LA IA (Sección 3 del MD)
      if (response.action == "OPEN_SPOTIFY" && response.data != null) {
        final Uri url = Uri.parse(response.data!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
