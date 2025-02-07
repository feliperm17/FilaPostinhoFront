//import 'package:http/http.dart' as http;
import '../models/queue_model.dart';
import 'dart:convert';
import 'api_service.dart';

class QueueService {
  final ApiService apiService;

  QueueService(this.apiService);

  Future<Queue> create(Queue queue) async {
    final response = await apiService.post('queue', queue.toJson());
    if (response.statusCode == 201) {
      return Queue.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create queue');
    }
  }

  Future<List<Queue>> findAll(String token_) async {
    final response = await apiService.get('queue', token_);
    if (response.statusCode == 200) {
      List<dynamic> queuesJson = jsonDecode(response.body);
      return queuesJson.map((json) => Queue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load queues');
    }
  }

  Future<Queue> findById(String id, String token_) async {
    final response = await apiService.get('queue/$id', token_);
    if (response.statusCode == 200) {
      return Queue.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load queue');
    }
  }

  Future<Queue> update(String id, Queue queue) async {
    final response = await apiService.put('queue/$id', queue.toJson());
    if (response.statusCode == 200) {
      return Queue.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update queue');
    }
  }

  Future<void> delete(String id) async {
    final response = await apiService.delete('queue/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete queue');
    }
  }
}