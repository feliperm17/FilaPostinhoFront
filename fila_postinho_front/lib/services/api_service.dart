import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/jwt_token.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<http.Response> get(String endpoint, String token_) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': '$jwtToken',
    };
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': '$jwtToken',
    };
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$jwtToken',
        },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'),
    headers: {
        'Content-Type': 'application/json',
        'Authorization': '$jwtToken',
        },
    );
    return response;
  }
}