import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fila_postinho_front/core/api_config.dart';
import 'package:fila_postinho_front/models/user_model.dart';

class AuthService {
  User? currentUser;

  Future<Map<String, dynamic>> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.register),
        headers: ApiConfig.headers,
        body: jsonEncode(user.toJson()),
      );

      final responseBody = jsonDecode(response.body);

      // Tratar códigos de status diferentes de 201
      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Cadastro realizado com sucesso'};
      } else {
        // Mapear o campo 'error' do backend para 'message' no front
        return {
          'success': false,
          'message': responseBody['error'] ?? 'Erro desconhecido no cadastro'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString().replaceAll(RegExp(r'^Exception: '), '')}'
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

  User? getCurrentUser() {
    return currentUser;
  }

  Future<void> logout() async {
    currentUser = null;
  }

  Future<void> updateUser(User updatedUser) async {
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
