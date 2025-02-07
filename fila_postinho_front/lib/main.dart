import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_page.dart';
import 'screens/auth/profile_screen.dart';
import 'screens/specialty/specialty_management_screen.dart';
import 'screens/queue/queue_management_screen.dart';
import 'screens/auth/admin_home_page.dart';
import 'core/theme/colors.dart';
import 'services/specialty_service.dart';
import 'services/api_service.dart';
import 'services/auth_storage_service.dart';
import 'utils/jwt_token.dart';
//import '../../utils/jwt_token.dart';
//import '';

void main() {
  final apiService = ApiService('http://localhost:3000');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpecialtyService(apiService)),
      ],
      child: const MyApp(),
    ),
  );
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

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load token from storage
  jwtToken = await AuthStorageService.getToken();
  
  final apiService = ApiService('http://localhost:3000');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpecialtyService(apiService)),
      ],
      child: const MyApp(),
    ),
  );
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
        '/admin/home': (context) => AdminHome(toggleTheme: _toggleTheme),
        '/manage_queue': (context) =>
            QueueManagementScreen(toggleTheme: _toggleTheme),
        '/manage_specialties': (context) =>
            SpecialtyManagementScreen(toggleTheme: _toggleTheme),
      },
    );
  }
}
