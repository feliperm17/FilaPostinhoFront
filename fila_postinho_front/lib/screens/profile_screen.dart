import 'package:fila_postinho_front/models/user_model.dart';
import 'package:flutter/material.dart';
import '../utils/current_user.dart';
//import 'package:fila_postinho_front/shared/utils/current_user.dart';
import 'package:fila_postinho_front/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/services/auth_service.dart';
//import 'package:fila_postinho_front/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final VoidCallback toggleTheme;

  ProfileScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: [
          ThemeToggleButton(
            onPressed: toggleTheme,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informações do Usuário', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              if (currentUser != null) ...[
                Text('Nome: ${currentUser?.name}'),
                SizedBox(height: 10),
                Text('E-mail: ${currentUser?.email}'),
                SizedBox(height: 10),
                Text('Telefone: ${currentUser?.number}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showEditDialog(context, currentUser!);
                  },
                  child: Text('Editar Informações'),
                ),
              ] else ...[
                Text('Usuário não encontrado.'),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _authService.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                child: Text('Logout'),
              ),
              SizedBox(height: 20),
              if (currentUser != null && currentUser!.isAdmin)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/manage_specialties');
                  },
                  child: Text('Gerenciar Especialidades'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    final TextEditingController nameController =
        TextEditingController(text: user.name);
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController phoneController =
        TextEditingController(text: user.number);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Informações'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Atualiza os dados do usuário no backend
                User updatedUser = User(
                  id: user.id,
                  name: nameController.text,
                  cpf: user.cpf,
                  email: emailController.text,
                  number: user.number,
                  isAdmin: user.isAdmin,
                );

                await _authService.updateUser(updatedUser);

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
