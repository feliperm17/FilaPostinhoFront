//import 'package:http/http.dart' as http;
import '../models/queue_model.dart';
import '../models/item_model.dart';
import '../models/specialty_model.dart';
import 'dart:convert';
import 'api_service.dart';
import '../models/user_model.dart';

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

  Future<Queue> findById(int id, String token_) async {
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

  Future<String> join(Specialty specialty) async {
    final response =
        await apiService.postNoBody('queue/${specialty.specialtyId}/join');
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to create queue');
    }
  }

  Future<QueueItem> getPosition() async {
    final response = await apiService.get('queue/position', '');
    if (response.statusCode == 200) {
      return QueueItem.fromJson(jsonDecode(response.body));
    } else {
      return QueueItem.notOnQueue();
    }
  }

  Future<QueueItem> getOtherPosition(int id) async {
    final response = await apiService.get('queue/$id/position', '');
    if (response.statusCode == 200) {
      return QueueItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load queue');
    }
  }

  Future<String> leaveQueue(int queueId) async {
    final response = await apiService.postNoBody('queue/$queueId/leave');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load queue');
    }
  }

  Future<List<User>> getQueueUsers(String queueId, String token) async {
    final response = await apiService.get('queue/$queueId/users', token);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar usuários da fila');
    }
  }

  Future<QueueItemAccount> advanceQueue(int queueId) async {
    final response = await apiService.postNoBody('queue/$queueId/next');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> current = data['current'];
      QueueItemAccount item = QueueItemAccount.fromJson(current);
      return item;
    } else {
      throw Exception('Erro ao buscar usuários da fila');
    }
  }

  Future<QueueItemAccount> skipQueue(int queueId) async {
    final response = await apiService.postNoBody('queue/$queueId/skip');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> current = data['current'];
      QueueItemAccount item = QueueItemAccount.fromJson(current);
      return item;
    } else {
      throw Exception('Erro ao buscar usuários da fila');
    }
  }

  Future<QueueItemAccount> confirmQueue(int queueId) async {
    final response = await apiService.postNoBody('queue/$queueId/confirm');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> current = data['current'];
      QueueItemAccount item = QueueItemAccount.fromJson(current);
      return item;
    } else {
      throw Exception('Erro ao buscar usuários da fila');
    }
  }
}
