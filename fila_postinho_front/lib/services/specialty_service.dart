//import 'package:http/http.dart' as http;
import '../models/specialty_model.dart';
import 'dart:convert';
import 'api_service.dart';

class SpecialtyService {
  final ApiService apiService;

  SpecialtyService(this.apiService);

  Future<Specialty> create(Specialty specialty) async {
    final response = await apiService.post('specialties', specialty.toJson());
    if (response.statusCode == 201) {
      return Specialty.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create specialty');
    }
  }

  Future<List<Specialty>> findAll() async {
    final response = await apiService.get('specialties');
    if (response.statusCode == 200) {
      List<dynamic> specialtiesJson = jsonDecode(response.body);
      return specialtiesJson.map((json) => Specialty.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load specialties');
    }
  }

  Future<Specialty> findById(String id) async {
    final response = await apiService.get('specialties/$id');
    if (response.statusCode == 200) {
      return Specialty.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load specialty');
    }
  }

  Future<Specialty> update(String id, Specialty specialty) async {
    final response = await apiService.put('specialties/$id', specialty.toJson());
    if (response.statusCode == 200) {
      return Specialty.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update specialty');
    }
  }

  Future<void> delete(String id) async {
    final response = await apiService.delete('specialties/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete specialty');
    }
  }
}