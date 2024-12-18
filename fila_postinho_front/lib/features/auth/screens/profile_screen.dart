import 'package:flutter/material.dart';
import 'package:fila_postinho_front/shared/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/features/auth/services/auth_service.dart';
import 'package:fila_postinho_front/features/auth/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final VoidCallback toggleTheme;

  ProfileScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    UserModel? currentUser = _authService.getCurrentUser();

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
                Text('Nome: ${currentUser.name}'),
                SizedBox(height: 10),
                Text('E-mail: ${currentUser.email}'),
                SizedBox(height: 10),
                Text('Telefone: ${currentUser.phone}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showEditDialog(context, currentUser);
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
              if (currentUser != null && currentUser.isAdmin)
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

  void _showEditDialog(BuildContext context, UserModel user) {
    final TextEditingController nameController =
        TextEditingController(text: user.name);
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController phoneController =
        TextEditingController(text: user.phone);

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
                UserModel updatedUser = UserModel(
                  id: user.id,
                  name: nameController.text,
                  cpf: user.cpf,
                  email: emailController.text,
                  password: user.password,
                  cep: user.cep,
                  street: user.street,
                  city: user.city,
                  neighborhood: user.neighborhood,
                  state: user.state,
                  phone: phoneController.text,
                  birthDate: user.birthDate,
                  country: user.country,
                  number: user.number,
                  complement: user.complement,
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
