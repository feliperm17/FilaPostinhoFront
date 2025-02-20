import 'package:flutter/material.dart';
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
  String token = "";

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
      return await specialtyService.findAll(token);
    } catch (e) {
      throw Exception('Não foi possível carregar as especialidades: $e');
    }
  }

  void _addSpecialty() async {
    if (_specialtyController.text.isEmpty) return;
    final newSpecialty = Specialty(specialtyName: _specialtyController.text);
    try {
      final specialtyService =
          Provider.of<SpecialtyService>(context, listen: false);
      await specialtyService.create(newSpecialty);
      _specialtyController.clear();
      setState(() {
        _specialtiesFuture = _fetchSpecialties();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar: $e')),
      );
    }
  }

  void _editSpecialty(Specialty specialty) {
    _specialtyController.text = specialty.specialtyName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Especialidade'),
          content: TextField(
            controller: _specialtyController,
            decoration: const InputDecoration(labelText: 'Especialidade'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final updatedSpecialty = Specialty(
                    specialtyId: specialty.specialtyId,
                    specialtyName: _specialtyController.text,
                  );
                  final specialtyService =
                      Provider.of<SpecialtyService>(context, listen: false);
                  await specialtyService.update(
                      specialty.specialtyId.toString(), updatedSpecialty);
                  _specialtyController.clear();
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
              TextField(
                controller: _specialtyController,
                decoration:
                    const InputDecoration(labelText: 'Nova Especialidade'),
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