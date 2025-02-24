import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/queue_services.dart';
import '../../models/queue_model.dart';
import '../../services/specialty_service.dart';
import '../../models/specialty_model.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/background_gradient.dart';
import '../../services/auth_storage_service.dart';


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
  final TextEditingController _patientController = TextEditingController();
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

  String? token = await AuthStorageService.getToken();  // PEGAR O TOKEN DO USUÁRIO

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
    try {
      final newQueue = Queue(
        queueId: null,
        specialty: selectedSpecialty!.specialtyId!,
        queueDt: DateTime.parse(_queueDateController.text),
        positionNr: 0,
        queueSize: 0,
      );
      await queueService.create(newQueue);
      _showSnackBar('Fila adicionada com sucesso!');
      _fetchData();
    } catch (e) {
      _showSnackBar('Erro ao adicionar fila: $e');
    }
  }

  Future<void> _movePatient(Queue queue, int direction) async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      await queueService.movePatient(queue.queueId!.toString(), direction);
      _showSnackBar('Paciente movido na fila!');
      _fetchData();
    } catch (e) {
      _showSnackBar('Erro ao mover paciente: $e');
    }
  }

  Future<void> _changeQueueSpecialty(Queue queue, Specialty newSpecialty) async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      await queueService.updateQueueSpecialty(queue.queueId!.toString(), newSpecialty.specialtyId!);
      _showSnackBar('Especialidade da fila atualizada!');
      _fetchData();
    } catch (e) {
      _showSnackBar('Erro ao alterar especialidade: $e');
    }
  }

  Future<void> _removeQueue(int queueId) async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      await queueService.delete(queueId.toString());
      _showSnackBar('Fila removida!');
      _fetchData();
    } catch (e) {
      _showSnackBar('Erro ao remover fila: $e');
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
                      onChanged: (value) {
                        setState(() => selectedSpecialty = value);
                      },
                      items: specialties.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s.specialtyName),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: _queueDateController,
                      decoration: const InputDecoration(labelText: 'Data da Fila (YYYY-MM-DD)'),
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addQueue,
                      child: const Text('Adicionar Fila'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: queues.length,
                        itemBuilder: (context, index) {
                          final queue = queues[index];
                          return ListTile(
                            title: Text('Fila ID: ${queue.queueId}'),
                            subtitle: Text('Especialidade: ${queue.specialty}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_upward),
                                  onPressed: () => _movePatient(queue, -1),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_downward),
                                  onPressed: () => _movePatient(queue, 1),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.swap_horiz),
                                  onPressed: () => _changeQueueSpecialty(queue, selectedSpecialty!),
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
