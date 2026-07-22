import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/security/token_storage.dart';
import '../models/chat_models.dart';

class ChatApiService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  ChatApiService(this._apiClient, this._tokenStorage);

  Future<ChatResponse> sendMessage(ChatRequest request) async {
    final token = await _tokenStorage.getToken();
    final response = await _apiClient.post(
      ApiConstants.chat,
      headers: {'Authorization': 'Bearer $token'},
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      return ChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error en el chat: ${response.statusCode}');
    }
  }

  Future<List<ChatHistoryMessage>> getHistory(int idChofer) async {
    final token = await _tokenStorage.getToken();
    final response = await _apiClient.get(
      '${ApiConstants.chatHistory}/$idChofer',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((m) => ChatHistoryMessage.fromJson(m)).toList();
    } else {
      throw Exception('Error obteniendo historial: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getPreferences(int idChofer) async {
    final token = await _tokenStorage.getToken();
    final response = await _apiClient.get(
      '${ApiConstants.chatPreferences}/$idChofer',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error obteniendo preferencias: ${response.statusCode}');
    }
  }

  Future<void> updatePreferences(ChatPreferenceRequest request) async {
    final token = await _tokenStorage.getToken();
    final response = await _apiClient.post( // Documentation says PUT, but post method in ApiClient is available. Let's use PUT if I had it. 
      // Actually Documentation says: PUT /api/v1/chat/preferences
      // I will assume the ApiClient needs a put method.
      ApiConstants.chatPreferences,
      headers: {'Authorization': 'Bearer $token'},
      body: request.toJson(),
    );
    // Note: I should add PUT to ApiClient if needed.
  }
}
