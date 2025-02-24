import '../models/queue_model.dart';
import '../models/user_model.dart';
import 'dart:convert';
import 'api_service.dart';

class QueueService {
  final ApiService apiService;

  QueueService(this.apiService);

  Future<Queue> create(Queue queue, String token_) async {
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

  Future<Queue> update(String id, Queue queue, String token_) async {
    final response = await apiService.put('queue/$id', queue.toJson());
    if (response.statusCode == 200) {
      return Queue.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update queue');
    }
  }

  Future<void> delete(String id, String token_) async {
    final response = await apiService.delete('queue/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete queue');
    }
  }

  Future<List<User>> getQueueUsers(String queueId, String token_) async {
    final response = await apiService.get('queue/$queueId/users', token_);
    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load queue users');
    }
  }

  Future<void> joinQueue(String queueId, String token_) async {
    final response = await apiService.post('queue/$queueId/join', {});
    if (response.statusCode != 201) {
      throw Exception('Failed to join queue');
    }
  }

  Future<int> getUserPosition(String queueId, String token_) async {
    final response = await apiService.get('queue/$queueId/position', token_);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['position'];
    } else {
      throw Exception('Failed to get user position');
    }
  }

  Future<void> advanceQueue(String queueId, String token_) async {
    final response = await apiService.post('queue/$queueId/next', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to advance queue');
    }
  }

  Future<List<User>> getFullQueue(String queueId, String token_) async {
    final response = await apiService.get('queue/$queueId/all', token_);
    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load full queue');
    }
  }
}