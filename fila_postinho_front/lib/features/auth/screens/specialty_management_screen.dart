import 'package:flutter/material.dart';
import 'package:fila_postinho_front/shared/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/shared/widgets/background_gradient.dart';

class SpecialtyManagementScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SpecialtyManagementScreen({super.key, required this.toggleTheme});

  @override
  SpecialtyManagementScreenState createState() =>
      SpecialtyManagementScreenState();
}

class SpecialtyManagementScreenState extends State<SpecialtyManagementScreen> {
  final List<String> specialties = [];
  final TextEditingController _specialtyController = TextEditingController();

  void _addSpecialty() {
    if (_specialtyController.text.isNotEmpty) {
      setState(() {
        specialties.add(_specialtyController.text);
        _specialtyController.clear();
      });
    }
  }

  void _removeSpecialty(int index) {
    setState(() {
      specialties.removeAt(index);
    });
  }

  void _editSpecialty(int index) {
    _specialtyController.text = specialties[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Especialidade'),
          content: TextField(
            controller: _specialtyController,
            decoration: InputDecoration(labelText: 'Especialidade'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  specialties[index] = _specialtyController.text;
                  _specialtyController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gerenciamento de Especialidades'),
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
              TextField(
                controller: _specialtyController,
                decoration: InputDecoration(labelText: 'Nova Especialidade'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addSpecialty,
                child: Text('Adicionar Especialidade'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: specialties.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(specialties[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editSpecialty(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeSpecialty(index),
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
