import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fila_postinho_front/core/api_config.dart';
import 'package:fila_postinho_front/features/auth/models/user_model.dart';

class AuthService {
  Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.register),
        headers: ApiConfig.headers,
        body: jsonEncode(user.toJson()),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro ao conectar com o servidor: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.login),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro ao conectar com o servidor: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.resetPassword),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'email': email,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro ao conectar com o servidor: ${e.toString()}'
      };
    }
  }
}
