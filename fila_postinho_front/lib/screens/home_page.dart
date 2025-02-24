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
  final TextEditingController patientController = TextEditingController();
  String token = "";

  @override
  void initState() {
    super.initState();
    _loadToken();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _fetchQueues());
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
    super.dispose();
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

  bool _isDateValidForSpecialty(DateTime date) {
    //Falta implementar
    //Precisa adicionar a data no modelo
    return true;
  }

  void _checkAuthentication() {
    if (token.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSessionExpiredDialog(context);
      });
    }
  }

  void _showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sessão Expirada'),
        content: const Text('Sua sessão expirou. Faça login novamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchQueues() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      final fetchedQueues = await queueService.findAll(token);
      if (mounted) {
        setState(() {
          queues = fetchedQueues;
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(context, 'Failed to load queues: $e');
      }
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                  Text(
                    selectedDate != null
                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                        : "Selecione a data",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _enterQueue(context);
                },
                child: const Text('Entrar na Fila'),
              ),
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

    final queueService = Provider.of<QueueService>(context, listen: false);
    Specialty selected = selectedSpecialty!;

    try {
      int queueId;
      Queue queueEntry;
      int userPosition;
      queueId = await queueService.join(selected);
      queueEntry = await queueService.findById(queueId, 'token');
      userPosition = await queueService.getPosition(queueId, 'token');

      // Navigate to QueueInfoScreen with dynamic data
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QueueInfoScreen(
            patientName: currentUser?.name ?? "Nome do Paciente",
            currentTicket: userPosition,
            estimatedTime: (queueEntry.queueSize - queueEntry.positionNr) * 10,
            toggleTheme: widget.toggleTheme,
            specialtyName: selected.specialtyName,
          ),
        ),
      );
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
