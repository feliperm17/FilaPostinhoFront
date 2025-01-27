import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String themeKey = 'theme_mode';

  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }

  static Future<bool?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey);
  }
}
