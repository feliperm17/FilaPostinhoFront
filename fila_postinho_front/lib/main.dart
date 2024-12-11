import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final isDark = await StorageService.getThemeMode();
    if (isDark != null) {
      setState(() {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      StorageService.saveThemeMode(_themeMode == ThemeMode.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fila Postinho',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(false),
      darkTheme: AppTheme.buildTheme(true),
      themeMode: _themeMode,
      home: LoginScreen(toggleTheme: toggleTheme),
    );
  }
}
