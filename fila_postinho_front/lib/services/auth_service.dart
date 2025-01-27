import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fila_postinho_front/core/api_config.dart';
import 'package:fila_postinho_front/models/user_model.dart';

class AuthService {
  UserModel? currentUser;

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

  UserModel? getCurrentUser() {
    return currentUser;
  }

  Future<void> logout() async {
    currentUser = null;
  }

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/users/${updatedUser.id}'),
        body: jsonEncode(updatedUser.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        currentUser = updatedUser;
      } else {
        throw Exception('Falha ao atualizar usuário');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: ${e.toString()}');
    }
  }
}
