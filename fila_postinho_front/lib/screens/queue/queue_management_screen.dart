import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/queue_services.dart';
import '../../models/queue_model.dart';
import '../../services/specialty_service.dart';
import '../../models/specialty_model.dart';
import 'queue_user_list_screen.dart';
import '../../services/auth_storage_service.dart';
import '../../models/user_model.dart';
import 'package:intl/intl.dart';

class QueueManagementScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const QueueManagementScreen({super.key, required this.toggleTheme});

  @override
  State<QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<QueueManagementScreen> {
  late QueueService _queueService;
  List<Queue> _queues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _queueService = Provider.of<QueueService>(context, listen: false);
    _loadQueues();
  }

  Future<void> _fetchData() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    final specialtyService =
        Provider.of<SpecialtyService>(context, listen: false);
    String? token = await AuthStorageService.getToken();

    if (token == null || token.isEmpty) {
      _showSnackBar('Erro: Token inválido');
      return;
    }

    final queueService = Provider.of<QueueService>(context, listen: false);
    String? token = await AuthStorageService.getToken();

    try {
      final queues = await _queueService.findAll(token);
      final specialtyService =
          Provider.of<SpecialtyService>(context, listen: false);
      final specialties = await specialtyService.findAll(token);

      Map<int, String> specialtyMap = {
        for (var specialty in specialties)
          specialty.specialtyId!: specialty.specialtyName
      };

      setState(() {
        _queues = queues.map((queue) {
          return Queue(
            queueId: queue.queueId,
            specialty: queue.specialty,
            queueDt: queue.queueDt,
            positionNr: queue.positionNr,
            queueSize: queue.queueSize,
            specialtyName:
                specialtyMap[queue.specialty] ?? 'Especialidade Desconhecida',
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Erro ao carregar filas: $e');
    }
  }

  Future<void> _removeQueue(int queueId) async {
    try {
      await _queueService.delete(queueId.toString());
      _showSnackBar('Fila removida!');
      _loadQueues();
    } catch (e) {
      _showSnackBar('Erro ao remover fila: $e');
    }
  }

  Future<void> _showQueueUsers(int queueId) async {
    String? token = await AuthStorageService.getToken();
    if (token == null) return;

    try {
      final users =
          await _queueService.getQueueUsers(queueId.toString(), token);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Usuários na Fila $queueId'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(users[i].name),
                subtitle: Text(users[i].email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Remover usuário da fila',
                  onPressed: () => _removeUserFromQueue(queueId, users[i].id),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      _showSnackBar('Erro ao carregar usuários: $e');
    }
  }

  Future<void> _removeUserFromQueue(int queueId, int userId) async {
    String? token = await AuthStorageService.getToken();
    if (token == null) return;

    try {
      //await _queueService.removeUser(queueId.toString(), userId.toString(), token);
      _showSnackBar('Usuário removido da fila!');
      _showQueueUsers(queueId);
    } catch (e) {
      _showSnackBar('Erro ao remover usuário: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciamento de Filas'),
          actions: [
            ThemeToggleButton(
              onPressed: widget.toggleTheme,
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<Specialty>(
                      hint: const Text('Selecione uma Especialidade'),
                      value: selectedSpecialty,
                      onChanged: (value) =>
                          setState(() => selectedSpecialty = value),
                      items: specialties
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.specialtyName),
                              ))
                          .toList(),
                    ),
                    TextField(
                      controller: _queueDateController,
                      decoration: const InputDecoration(
                          labelText: 'Data da Fila (YYYY-MM-DD)'),
                    ),
                    ElevatedButton(
                      onPressed: _addQueue,
                      child: const Text('Adicionar Fila'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: queues.length,
                        itemBuilder: (context, index) {
                          final queue = queues[index];
                          return ListTile(
                            title: Text('Fila ID: ${queue.queueId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text('Especialidade: ${queue.getSpecialtyName(specialties)}'),
                                Text('Tamanho: ${queue.queueSize}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //IconButton(
                                //icon: const Icon(Icons.people),
                                //onPressed: () => _showQueueUsers(queue.queueId!),
                                //),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _removeQueue(queue.queueId!),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _queues.length,
              itemBuilder: (context, index) {
                final queue = _queues[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    title: Text(
                        'Fila: ${queue.specialtyName ?? "Especialidade Desconhecida"} - ${DateFormat('dd/MM/yyyy').format(queue.queueDt)}'),
                    subtitle:
                        Text('Tamanho da Fila: ${queue.queueSize} pessoas'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.people),
                          onPressed: () {
                            final queueId = queue.queueId;
                            Navigator.of(context).pushNamed(
                              '/queue_users',
                              arguments: queueId,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
