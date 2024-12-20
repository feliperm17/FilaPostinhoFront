import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/home_page.dart';
import 'features/auth/screens/profile_screen.dart';
import 'features/auth/screens/specialty_management_screen.dart';
import 'features/auth/screens/queue_management_screen.dart';
import 'core/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _themeIndex = 0; // 0: Light, 1: Dark, 2: Colorido

  void _toggleTheme() {
    setState(() {
      _themeIndex = (_themeIndex + 1) % 3; // Alterna entre 3 temas
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme;
    if (_themeIndex == 0) {
      theme = ThemeData.light().copyWith(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      );
    } else if (_themeIndex == 1) {
      theme = ThemeData.dark().copyWith(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.grey[900],
      );
    } else {
      theme = ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.yellow[100],
      );
    }

    return MaterialApp(
      title: 'Fila Postinho',
      theme: theme,
      initialRoute: '/login',
      routes: {
        '/register': (context) => LoginScreen(toggleTheme: _toggleTheme),
        '/login': (context) => LoginScreen(toggleTheme: _toggleTheme),
        '/home': (context) => HomePage(toggleTheme: _toggleTheme),
        '/profile': (context) => ProfileScreen(toggleTheme: _toggleTheme),
        '/manage_specialties': (context) =>
            SpecialtyManagementScreen(toggleTheme: _toggleTheme),
        '/manage_queue': (context) =>
            QueueManagementScreen(toggleTheme: _toggleTheme),
      },
    );
  }
}
