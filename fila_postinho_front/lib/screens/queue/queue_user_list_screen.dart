import 'package:fila_postinho_front/services/queue_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../models/item_model.dart';
import '../../services/queue_services.dart';
import '../../services/user_service.dart';
import '../../services/auth_storage_service.dart';

class QueueUsersScreen extends StatefulWidget {
  final int queueId;

  const QueueUsersScreen({super.key, required this.queueId});

  @override
  State<QueueUsersScreen> createState() => _QueueUsersScreenState();
}

class _QueueUsersScreenState extends State<QueueUsersScreen> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      final users =
          await queueService.getQueueUsers(widget.queueId.toString(), ' ');
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Erro ao carregar usuários: $e');
    }
  }

  Future<void> _advanceQueue() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    try {
      final QueueItemAccount item =
          await queueService.advanceQueue(widget.queueId);
      final User nextUser = await userService.findUserById(item.account!, ' ');
      // Exibe as informações do usuário chamado em um diálogo.
      if (item.account != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Próximo Usuário"),
            content: nextUser != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nome: ${nextUser.name}"),
                      Text("Email: ${nextUser.email}"),
                      Text("Telephone: ${nextUser.number}"),
                    ],
                  )
                : const Text("Nenhum usuário na fila."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }

      _showSnackBar('Fila avançada com sucesso!');
      await _loadUsers(); // Atualiza a lista de usuários.
    } catch (e) {
      _showSnackBar('Erro ao avançar fila: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários na Fila'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _advanceQueue,
                    child: const Text('Avançar Fila'),
                  ),
                ),
              ],
            ),
    );
  }
}
