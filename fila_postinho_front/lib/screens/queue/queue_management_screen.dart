import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/queue_services.dart';
import '../../models/queue_model.dart';
import '../../services/specialty_service.dart';
import '../../models/specialty_model.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/background_gradient.dart';
import '../../services/auth_storage_service.dart';
import '../../models/user_model.dart';

class QueueManagementScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const QueueManagementScreen({super.key, required this.toggleTheme});

  @override
  State<QueueManagementScreen> createState() => QueueManagementScreenState();
}

class QueueManagementScreenState extends State<QueueManagementScreen> {
  List<Queue> queues = [];
  List<Specialty> specialties = [];
  final TextEditingController _queueDateController = TextEditingController();
  Specialty? selectedSpecialty;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    final specialtyService = Provider.of<SpecialtyService>(context, listen: false);
    String? token = await AuthStorageService.getToken();

    if (token != null) {
      try {
        final fetchedQueues = await queueService.findAll(token);
        final fetchedSpecialties = await specialtyService.findAll(token);
        setState(() {
          queues = fetchedQueues;
          specialties = fetchedSpecialties;
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);
        _showSnackBar('Erro ao carregar dados: $e');
      }
    } else {
      _showSnackBar('Erro: Token não encontrado');
    }
  }

  Future<void> _addQueue() async {
    if (selectedSpecialty == null || _queueDateController.text.isEmpty) {
      _showSnackBar('Selecione uma especialidade e defina uma data.');
      return;
    }

    final queueService = Provider.of<QueueService>(context, listen: false);
    String? token = await AuthStorageService.getToken();
    
    try {
      final newQueue = Queue(
        queueId: null,
        specialty: selectedSpecialty!.specialtyId!,
        queueDt: DateTime.parse(_queueDateController.text),
        positionNr: 0,
        queueSize: 0,
      );
      await queueService.create(newQueue, token!);
      _showSnackBar('Fila adicionada com sucesso!');
      _fetchData();
    } catch (e) {
      _showSnackBar('Erro ao adicionar fila: $e');
    }
  }

  Future<void> _removeQueue(int queueId) async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    String? token = await AuthStorageService.getToken();

    try {
      await queueService.delete(queueId.toString(), token!);
      _showSnackBar('Fila removida!');
      _fetchData();
    } catch (e) {
      _showSnackBar('Erro ao remover fila: $e');
    }
  }

  Future<void> _showQueueUsers(int queueId) async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    String? token = await AuthStorageService.getToken();

    try {
      final users = await queueService.getQueueUsers(queueId.toString(), token!);
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
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      _showSnackBar('Erro ao carregar usuários: $e');
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
                      onChanged: (value) => setState(() => selectedSpecialty = value),
                      items: specialties.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.specialtyName),
                      )).toList(),
                    ),
                    TextField(
                      controller: _queueDateController,
                      decoration: const InputDecoration(labelText: 'Data da Fila (YYYY-MM-DD)'),
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
                                IconButton(
                                  icon: const Icon(Icons.people),
                                  onPressed: () => _showQueueUsers(queue.queueId!),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}