import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_provider/models/settings.dart';

class StorageHelper {
  static const String _useDarkTheme = 'useDarkTheme';

  Future<Settings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return Settings(
      useDarkTheme: prefs.containsKey(_useDarkTheme)
          ? prefs.getBool(_useDarkTheme)
          : false,
    );
  }

  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_useDarkTheme, settings.useDarkTheme);
  }
}
