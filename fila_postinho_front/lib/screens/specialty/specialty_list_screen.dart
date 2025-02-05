import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/specialty_service.dart';
import '../../models/specialty_model.dart';

class SpecialtyListScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const SpecialtyListScreen({
    required this.toggleTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final specialtyService = Provider.of<SpecialtyService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Especialidades')),
      body: FutureBuilder<List<Specialty>>(
        future: specialtyService.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
