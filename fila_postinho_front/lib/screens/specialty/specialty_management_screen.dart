import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/widgets/background_gradient.dart';
import 'package:fila_postinho_front/services/specialty_service.dart';
import 'package:fila_postinho_front/models/specialty_model.dart';
import 'package:fila_postinho_front/services/auth_storage_service.dart';

class SpecialtyManagementScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SpecialtyManagementScreen({super.key, required this.toggleTheme});

  @override
  SpecialtyManagementScreenState createState() =>
      SpecialtyManagementScreenState();
}

class SpecialtyManagementScreenState extends State<SpecialtyManagementScreen> {
  late Future<List<Specialty>> _specialtiesFuture;
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _estimatedTimeController = TextEditingController();
  String token = "";
  Set<int> _selectedDays = {};
  final List<String> _daysOfWeek = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? savedToken = await AuthStorageService.getToken();
    setState(() {
      token = savedToken ?? "";
      _specialtiesFuture = _fetchSpecialties();
    });
  }

  Future<List<Specialty>> _fetchSpecialties() async {
    if (token.isEmpty) return [];
    final specialtyService =
        Provider.of<SpecialtyService>(context, listen: false);
    try {
      // Pass the token to findAll
      return await specialtyService.findAll(token);
    } catch (e) {
      throw Exception('Não foi possível carregar as especialidades: $e');
    }
  }

  List<Widget> _buildDayCheckboxes(
      Set<int> selectedDays, Function(bool?, int) onDaySelected) {
    return List.generate(7, (index) {
      return CheckboxListTile(
        title: Text(_daysOfWeek[index]),
        value: selectedDays.contains(index),
        onChanged: (value) => onDaySelected(value, index),
      );
    }).toList();
  }

  void _addSpecialty() async {
    if (_specialtyController.text.isEmpty ||
        _estimatedTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    try {
      int estimatedTime = int.parse(_estimatedTimeController.text);
      final newSpecialty = Specialty(
        specialtyName: _specialtyController.text,
        availableDays: _selectedDays.toList(),
        estimatedTime: estimatedTime,
      );
      final specialtyService =
          Provider.of<SpecialtyService>(context, listen: false);
      await specialtyService.create(newSpecialty);
      _specialtyController.clear();
      _estimatedTimeController.clear();
      setState(() {
        _specialtiesFuture = _fetchSpecialties();
        _selectedDays.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar: $e')),
      );
    }
  }

  void _editSpecialty(Specialty specialty) {
    _specialtyController.text = specialty.specialtyName;
    _estimatedTimeController.text = specialty.estimatedTime.toString();
    Set<int> selectedDays = Set.from(specialty.availableDays);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Especialidade'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _specialtyController,
                            decoration:
                                const InputDecoration(labelText: 'Especialidade'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _estimatedTimeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(
                                labelText: 'Tempo Estimado (minutos)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Dias disponíveis:'),
                    ..._buildDayCheckboxes(
                      selectedDays,
                      (value, index) {
                        setState(() {
                          if (value!) {
                            selectedDays.add(index);
                          } else {
                            selectedDays.remove(index);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      int estimatedTime =
                          int.parse(_estimatedTimeController.text);
                      final updatedSpecialty = Specialty(
                        specialtyId: specialty.specialtyId,
                        specialtyName: _specialtyController.text,
                        availableDays: selectedDays.toList(),
                        estimatedTime: estimatedTime,
                      );
                      final specialtyService =
                          Provider.of<SpecialtyService>(context, listen: false);
                      await specialtyService.update(
                          specialty.specialtyId.toString(), updatedSpecialty);
                      
                      // Clear controllers AFTER successful update
                      _specialtyController.clear();
                      _estimatedTimeController.clear();
                      
                      // Refresh list
                      setState(() {
                        _specialtiesFuture = _fetchSpecialties();
                      });
                      
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao editar: $e')),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteSpecialty(String id) async {
    try {
      final specialtyService =
          Provider.of<SpecialtyService>(context, listen: false);
      await specialtyService.delete(id);
      setState(() {
        _specialtiesFuture = _fetchSpecialties();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciamento de Especialidades'),
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _specialtyController,
                      decoration:
                          const InputDecoration(labelText: 'Nome da Especialidade'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _estimatedTimeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          labelText: 'Tempo Estimado (minutos)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Dias disponíveis:'),
              Column(
                children: _buildDayCheckboxes(
                  _selectedDays,
                  (value, index) {
                    setState(() {
                      if (value!) {
                        _selectedDays.add(index);
                      } else {
                        _selectedDays.remove(index);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addSpecialty,
                child: const Text('Adicionar Especialidade'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Specialty>>(
                  future: _specialtiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Nenhuma especialidade cadastrada'));
                    } else {
                      final specialties = snapshot.data!;
                      return ListView.builder(
                        itemCount: specialties.length,
                        itemBuilder: (context, index) {
                          final specialty = specialties[index];
                          return ListTile(
                            title: Text(specialty.specialtyName),
                            subtitle: Text(
                              'Tempo estimado: ${specialty.estimatedTime} minutos\n'
                              'Dias disponíveis: ${specialty.availableDays.map((day) => _daysOfWeek[day]).join(', ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editSpecialty(specialty),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteSpecialty(
                                      specialty.specialtyId.toString()),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
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