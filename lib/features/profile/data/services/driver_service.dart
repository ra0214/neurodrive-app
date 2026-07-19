import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chofer_model.dart';

class DriverService {
  final String baseUrl = "https://api.neurodrive.ai/api/v1"; // Ajustar según corresponda
  final String? token;

  DriverService({this.token});

  Future<ChoferModel> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/choferes/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ChoferModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
