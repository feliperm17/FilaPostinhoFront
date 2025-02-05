//import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'dart:convert';
import 'api_service.dart';

class UserService {
  final ApiService apiService;

  UserService(this.apiService);

  Future<User> register(User user) async {
    final response = await apiService.post('auth/register', user.toJson());
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<User> login(String email, String password) async {
    final response = await apiService.post('auth/login', {'email': email, 'password': password});
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<User>> findAllUsers() async {
    final response = await apiService.get('users');
    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> findUserById(String id) async {
    final response = await apiService.get('users/$id');
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> updateUser(String id, User user) async {
    final response = await apiService.put('users/$id', user.toJson());
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await apiService.delete('users/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}