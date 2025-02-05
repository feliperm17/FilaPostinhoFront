import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fila_postinho_front/screens/auth/profile_screen.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/widgets/background_gradient.dart';
import '../screens/specialty/specialty_list_screen.dart';
import '../services/queue_services.dart';
import '../models/queue_model.dart';
import '../utils/current_user.dart';
import '../screens/auth/queue_info_screen.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Queue> queues = [];
  final TextEditingController patientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQueues();
  }

  @override
  void dispose() {
    patientController.dispose();
    super.dispose();
  }

  Future<void> _fetchQueues() async {
    final queueService = Provider.of<QueueService>(context, listen: false);
    try {
      final fetchedQueues = await queueService.findAll();
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
              ElevatedButton(
                onPressed: () {
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
                child: const Text(
                  'Selecionar Especialidade',
                  style: TextStyle(fontSize: 18),
                ),
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
                child: const Text(
                  'Entrar na Fila',
                  style: TextStyle(fontSize: 18),
                ),
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
    String patientName = currentUser?.name ?? "Nome do Paciente";
    int currentTicket = 1;
    int estimatedTime = 10;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QueueInfoScreen(
          patientName: patientName,
          currentTicket: currentTicket,
          estimatedTime: estimatedTime,
          toggleTheme: widget.toggleTheme,
        ),
      ),
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
