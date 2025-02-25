import 'package:flutter/material.dart';
import '../auth/profile_screen.dart';
import 'package:fila_postinho_front/core/theme/colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/background_gradient.dart';

class AdminHome extends StatelessWidget {
  final VoidCallback toggleTheme;

  const AdminHome({super.key, required this.toggleTheme});

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
                'Bem-vindo à Fila Postinho!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/manage_specialties');
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
                child: const Text('Gerenciar Especialidades',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //_navigateToManageQueues(context);
                  Navigator.pushNamed(context, '/manage_queue');
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
                child: const Text('Gerenciar Filas',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToManageSpecialties(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ManageSpecialtiesScreen(),
      ),
    );
  }

  void _navigateToManageQueues(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ManageQueuesScreen(),
      ),
    );
  }
}

class ManageSpecialtiesScreen extends StatelessWidget {
  const ManageSpecialtiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Especialidades'),
      ),
      body: const Center(
        child: Text('Aqui você pode gerenciar as especialidades.'),
      ),
    );
  }
}

class ManageQueuesScreen extends StatelessWidget {
  const ManageQueuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Filas'),
      ),
      body: const Center(
        child: Text('Aqui você pode gerenciar as filas.'),
      ),
    );
  }
}
