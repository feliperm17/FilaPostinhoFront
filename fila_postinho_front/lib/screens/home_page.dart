import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fila_postinho_front/screens/auth/profile_screen.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/widgets/background_gradient.dart';
import '../screens/specialty/specialty_list_screen.dart';
import '../services/queue_services.dart';
import '../services/specialty_service.dart';
import '../models/queue_model.dart';
import '../models/specialty_model.dart';
import '../models/item_model.dart';
import '../utils/current_user.dart';
import '../screens/queue/queue_info_screen.dart';
//import '../screens/auth/queue_info_screen.dart';
import '../../utils/jwt_token.dart';
import '../../services/auth_storage_service.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Queue> queues = [];
  Specialty? selectedSpecialty;
  DateTime? selectedDate;
  QueueItem? _currentQueue;
  bool _isCheckingQueue = true;
  bool _isInQueue = false;
  late Timer _timer;
  final TextEditingController patientController = TextEditingController();
  String token = "";

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _fetchQueues());
  }

  void _startAutoRefresh() {
    _checkCurrentQueue();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkCurrentQueue();
    });
  }

  Future<void> _checkCurrentQueue() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      final queue = await queueService.getPosition();
      setState(() {
        if (queue.status != -1) {
          _currentQueue = queue;
        } else {
          _currentQueue = null;
        }
        _isCheckingQueue = false;
      });
    } catch (e) {
      setState(() => _isCheckingQueue = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar fila: $e')),
      );
    }
  }

  Future<void> _loadToken() async {
    String? savedToken = await AuthStorageService.getToken();
    debugPrint("Token carregado: $savedToken");
    setState(() {
      token = savedToken ?? "";
    });
  }

  @override
  void dispose() {
    patientController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Widget _buildQueueStatus() {
    // Captura o status da fila (1 = em andamento, 5 = dirigir à recepção)
    final status = _currentQueue?.status;

    Color containerColor;
    String statusMessage;
    IconData statusIcon;

    // Define cores e mensagens com base no status
    if (status == 1) {
      containerColor = Colors.orange[50]!;
      statusMessage = 'Consulta em Andamento';
      statusIcon = Icons.access_time_filled;
    } else if (status == 5) {
      containerColor = Colors.green[50]!;
      statusMessage = 'Dirija-se à Recepção';
      statusIcon = Icons.assignment_turned_in;
    } else {
      containerColor = Colors.blue[50]!;
      statusMessage = 'Você está na fila: ${_currentQueue?.queueId}';
      statusIcon = Icons.queue;
    }

    return GestureDetector(
      onTap: () {
        if (_currentQueue != null) {
          Navigator.pushNamed(
            context,
            '/queue',
            arguments: _currentQueue!.queueId.toString(),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: status == 1
                ? Colors.orange
                : status == 5
                    ? Colors.green
                    : Colors.blue,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon,
                    color: status == 1
                        ? Colors.orange
                        : status == 5
                            ? Colors.green
                            : Colors.blue),
                const SizedBox(width: 8),
                Text(
                  statusMessage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: status == 1
                            ? Colors.orange[800]
                            : status == 5
                                ? Colors.green[800]
                                : Colors.blue[800],
                      ),
                ),
              ],
            ),

            // Mostra detalhes apenas se não for status 1 ou 5
            if (status != 1 && status != 5) ...[
              const SizedBox(height: 12),
              _buildStatusRow(
                  'Posição:', _currentQueue?.position?.toString() ?? '--'),
              _buildStatusRow('Tempo estimado:',
                  '${_currentQueue?.estimatedTime?.toString() ?? '--'} min'),
              _buildStatusRow('Especialidade:',
                  _currentQueue?.specialty?.toString() ?? '--'),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                status == 1 ? '' : 'Aguarde orientação do atendente',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      selectableDayPredicate: (DateTime date) {
        //Falta Implementar
        return _isDateValidForSpecialty(date);
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  bool _isDateValidForSpecialty(DateTime date) {
    //Falta implementar
    //Precisa adicionar a data no modelo
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final specialtyService = Provider.of<SpecialtyService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(toggleTheme: widget.toggleTheme),
                ),
              );
            },
          ),
          ThemeToggleButton(
            onPressed: widget.toggleTheme,
            isDark: isDark,
          ),
        ],
      ),
      body: BackgroundGradient(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const Text(
                'a Unidade Básica de Saúde!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),
              if (!_isCheckingQueue && _currentQueue == null)
                FutureBuilder<List<Specialty>>(
                  future: specialtyService.findAll(token),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Erro: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Nenhuma especialidade disponível');
                    } else {
                      final specialties = snapshot.data!;
                      return DropdownButton<Specialty>(
                        isExpanded: true,
                        value: selectedSpecialty,
                        items: specialties.map((Specialty specialty) {
                          return DropdownMenuItem<Specialty>(
                            value: specialty,
                            child: Text(specialty.specialtyName),
                          );
                        }).toList(),
                        onChanged: (Specialty? newValue) {
                          if (newValue != null) {
                            // Find the corresponding specialty in the current list
                            final selected = specialties.firstWhere(
                              (s) => s == newValue,
                              orElse: () => newValue,
                            );
                            setState(() {
                              selectedSpecialty = selected;
                            });
                          }
                        },
                        hint: const Text('Selecionar Especialidade'),
                        underline: Container(),
                      );
                    }
                  },
                ),
              const SizedBox(height: 20),
              if (!_isCheckingQueue && _currentQueue == null)
                ElevatedButton(
                  onPressed: () {
                    _enterQueue(context);
                  },
                  child: const Text('Entrar na Fila'),
                ),
              const SizedBox(height: 20),
              if (_isCheckingQueue) const LinearProgressIndicator(),
              if (!_isCheckingQueue && _currentQueue != null)
                _buildQueueStatus(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: queues.length,
                  itemBuilder: (context, index) {
                    final queue = queues[index];
                    return ListTile(
                      title: Text('Queue ID: ${queue.queueId}'),
                      subtitle: Text('Specialty: ${queue.specialty}'),
                      onTap: () {},
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

  void _enterQueue(BuildContext context) async {
    if (selectedSpecialty == null) {
      _showSnackBar(context, 'Selecione uma especialidade');
      return;
    }
    if (selectedSpecialty == null) {
      _showSnackBar(context, 'Selecione uma especialidade');
      return;
    }

    final queueService = Provider.of<QueueService>(context, listen: false);
    Specialty selected = selectedSpecialty!;

    try {
      String queueId;
      queueId = await queueService.join(selected);

      Navigator.of(context).pushNamed('/queue', arguments: queueId);
    } catch (e) {
      _showSnackBar(context, 'Erro ao entrar na fila: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
