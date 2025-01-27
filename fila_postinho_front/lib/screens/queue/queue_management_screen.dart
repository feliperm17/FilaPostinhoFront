import 'package:flutter/material.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';

class QueueManagementScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const QueueManagementScreen({super.key, required this.toggleTheme});

  @override
  QueueManagementScreenState createState() => QueueManagementScreenState();
}

class QueueManagementScreenState extends State<QueueManagementScreen> {
  final List<String> queue = [];
  final TextEditingController _patientController = TextEditingController();
  String? selectedSpecialty;

  final List<String> specialties = []; // Lista de especialidades vazia

  void _addPatient() {
    if (_patientController.text.isNotEmpty && selectedSpecialty != null) {
      setState(() {
        queue.add('${_patientController.text} - ${selectedSpecialty!}');
        _patientController.clear();
      });
    } else {
      // Exibir um alerta se o paciente ou especialidade não estiverem definidos
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text(
                'Por favor, selecione uma especialidade e insira o nome do paciente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _removePatient(int index) {
    setState(() {
      queue.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Fila'),
        actions: [
          ThemeToggleButton(
            onPressed: widget.toggleTheme,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Selecione uma Especialidade'),
              value: selectedSpecialty,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSpecialty = newValue;
                });
              },
              items: specialties.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _patientController,
              decoration: InputDecoration(
                labelText: 'Nome do Paciente',
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addPatient,
              child: const Text('Adicionar Paciente à Fila'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: queue.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(queue[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removePatient(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
