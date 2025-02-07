import 'dart:convert';
import '../models/specialty_model.dart';
import 'api_service.dart';
import 'package:flutter/material.dart';

class SpecialtyService extends ChangeNotifier {
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

  Future<List<Specialty>> findAll(String token_) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token_',
    };
    try {
      final response = await apiService.get('specialties', token_);
      if (response.statusCode == 200) {
        List<dynamic> specialtiesJson = jsonDecode(response.body);
        return specialtiesJson.map((json) => Specialty.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ${response.statusCode}: Falha ao carregar especialidades.');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<Specialty> findById(String id, String token_) async {
    final response = await apiService.get('specialties/$id', token_);
    if (response.statusCode == 200) {
      return Specialty.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load specialty');
    }
  }

  Future<Specialty> update(String id, Specialty specialty) async {
    final response =
        await apiService.put('specialties/$id', specialty.toJson());
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
