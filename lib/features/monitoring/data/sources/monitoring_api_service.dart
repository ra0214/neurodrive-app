import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/security/token_storage.dart';
import '../models/monitoring_models.dart';

class MonitoringApiService {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  MonitoringApiService(this._apiClient, this._tokenStorage);

  Future<FatigueInferenceResponse> inferFatiga(FatigueInferenceRequest request) async {
    final token = await _tokenStorage.getToken();
    
    final response = await _apiClient.post(
      ApiConstants.inferFatiga,
      headers: {'Authorization': 'Bearer $token'},
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      return FatigueInferenceResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error en inferencia de fatiga: ${response.statusCode}');
    }
  }

  Future<void> logAlertaManual(Map<String, dynamic> alertData) async {
    final token = await _tokenStorage.getToken();
    await _apiClient.post(
      ApiConstants.logAlertaManual,
      headers: {'Authorization': 'Bearer $token'},
      body: alertData,
    );
  }
}
