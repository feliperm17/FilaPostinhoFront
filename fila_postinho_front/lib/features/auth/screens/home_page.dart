import 'package:flutter/material.dart';
import 'package:fila_postinho_front/features/auth/screens/profile_screen.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';
import 'package:fila_postinho_front/shared/widgets/theme_toggle_button.dart';
import 'package:fila_postinho_front/shared/widgets/background_gradient.dart';
import 'package:fila_postinho_front/features/auth/screens/queue_info_screen.dart';
import 'package:fila_postinho_front/features/auth/services/auth_service.dart';
import 'package:fila_postinho_front/features/auth/models/user_model.dart';

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final List<String> queue = []; // Lista para armazenar os pacientes
  final AuthService _authService = AuthService();

  HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(toggleTheme: toggleTheme),
                ),
              );
            },
          ),
          ThemeToggleButton(
            onPressed: toggleTheme,
            isDark: isDark,
          ),
        ],
      ),
      body: BackgroundGradient(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const Text(
                'a Unidade Básica de Saúde!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showSpecialtyDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Selecionar Especialidade',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _enterQueue(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Entrar na Fila',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSpecialtyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolha uma Especialidade'),
          content: const Text('As especialidades serão carregadas em breve.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _enterQueue(BuildContext context) {
    // Obtém o usuário logado
    UserModel? currentUser = _authService.getCurrentUser();

    // Verifica se o usuário está logado
    if (currentUser != null) {
      String patientName = currentUser.name; // Pega o nome do usuário logado
      int currentTicket = 657; // Exemplo, pegue do sistema
      int estimatedTime = 10; // Exemplo, pegue do sistema

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QueueInfoScreen(
            patientName: patientName,
            currentTicket: currentTicket,
            estimatedTime: estimatedTime,
            toggleTheme: toggleTheme,
          ),
        ),
      );
    } else {
      // Trate o caso em que não há usuário logado
      _showSnackBar(context, 'Usuário não está logado.', false);
    }
  }

  void _showSnackBar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
