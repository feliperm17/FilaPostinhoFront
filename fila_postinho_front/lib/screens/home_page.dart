import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fila_postinho_front/screens/profile_screen.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/widgets/background_gradient.dart';
import '../screens/specialty/specialty_list_screen.dart';
import '../services/queue_services.dart'; // Import QueueService
import '../models/queue_model.dart'; // Import Queue model

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Queue> queues = []; // List to store queues fetched from the backend

  @override
  void initState() {
    super.initState();
    _fetchQueues(); // Fetch queues when the widget is initialized
  }

  // Fetch queues from the backend
  Future<void> _fetchQueues() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      final fetchedQueues = await queueService.findAll();
      setState(() {
        queues = fetchedQueues;
      });
    } catch (e) {
      _showSnackBar(context, 'Failed to load queues: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(toggleTheme: widget.toggleTheme),
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
                'Bem-vindo à Fila Postinho!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate directly to SpecialtyListScreen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SpecialtyListScreen(
                        toggleTheme: widget.toggleTheme,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Selecionar Especialidade',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _enterQueue(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Entrar na Fila', style: TextStyle(fontSize: 18)),
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
                      onTap: () {
                        // Navigate to queue detail screen
                      },
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

  void _enterQueue(BuildContext context) {
    final TextEditingController patientController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Entrar na Fila'),
          content: TextField(
            controller: patientController,
            decoration: const InputDecoration(
              labelText: 'Nome do Paciente',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () async {
                if (patientController.text.isNotEmpty) {
                  final queueService = Provider.of<QueueService>(context, listen: false);
                  try {
                    // Create a new queue entry
                    final newQueue = Queue(
                      specialty: 1, // Replace with actual specialty ID
                      queueDt: DateTime.now(),
                      positionNr: queues.length + 1, // Next position in the queue
                      queueSize: queues.length + 1, // Update queue size
                    );
                    await queueService.create(newQueue);
                    _fetchQueues(); // Refresh the queue list
                    Navigator.of(context).pop();
                    _showSnackBar(context, 'Paciente adicionado à fila!');
                  } catch (e) {
                    _showSnackBar(context, 'Failed to add patient: $e');
                  }
                } else {
                  _showSnackBar(context, 'Por favor, insira um nome.');
                }
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}