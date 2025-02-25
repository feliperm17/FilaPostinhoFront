import 'package:flutter/material.dart';
import '../../services/specialty_service.dart';

class QueueInfoScreen extends StatelessWidget {
  final String patientName;
  final int currentTicket;
  final int estimatedTime;
  final VoidCallback toggleTheme;
  final String specialtyName; // Change from dynamic to String

  const QueueInfoScreen({
    super.key,
    required this.patientName,
    required this.currentTicket,
    required this.estimatedTime,
    required this.toggleTheme,
    required this.specialtyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações da Fila'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Olá Sr(a). $patientName, bem vindo(a) ao Posto de Saúde, você está na fila para:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              specialtyName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Sua Senha: $currentTicket',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Estimativa de Tempo: $estimatedTime min',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}