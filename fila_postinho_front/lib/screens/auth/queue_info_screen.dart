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
        title: Text('Informações da Fila'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Olá Sr(a). $patientName, bem vindo(a) ao Posto de Saúde X, você está na fila para:'),
            SizedBox(height: 20),
            Text('Cardiologia',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Sua Senha: $currentTicket', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Senha Atual: ${currentTicket - 2}',
                style: TextStyle(fontSize: 16)), // Exemplo
            SizedBox(height: 10),
            Text('Estimativa de Tempo: $estimatedTime min',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
