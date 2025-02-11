import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/specialty_service.dart';
import '../../models/specialty_model.dart';
import '../../services/auth_storage_service.dart';

class SpecialtyListScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SpecialtyListScreen({
    required this.toggleTheme,
    super.key,
  });

  @override
  _SpecialtyListScreenState createState() => _SpecialtyListScreenState();
}

class _SpecialtyListScreenState extends State<SpecialtyListScreen> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final specialtyService = Provider.of<SpecialtyService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Especialidades')),
      body: token.isEmpty
          ? const Center(child: Text('Carregando token...'))
          : FutureBuilder<List<Specialty>>(
              future: specialtyService.findAll(token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text('Carregando os dados do backend...'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar especialidades: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma especialidade encontrada'));
                } else {
                  final specialties = snapshot.data!;
                  return ListView.builder(
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      final specialty = specialties[index];
                      return ListTile(
                        title: Text(specialty.specialtyName),
                        onTap: () {
                          // Implementar navegação para a tela de detalhes
                        },
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
