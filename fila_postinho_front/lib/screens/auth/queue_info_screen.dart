import 'package:flutter/material.dart';

class QueueInfoScreen extends StatelessWidget {
  final String patientName;
  final int currentTicket;
  final int estimatedTime;
  final VoidCallback toggleTheme;

  const QueueInfoScreen({
    super.key,
    required this.patientName,
    required this.currentTicket,
    required this.estimatedTime,
    required this.toggleTheme,
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
              'Olá Sr(a). $patientName, bem vindo(a) ao Posto de Saúde X, você está na fila para:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Cardiologia',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Sua Senha: $currentTicket',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Senha Atual: ${currentTicket - 2}',
              style: const TextStyle(fontSize: 16),
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
