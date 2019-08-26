import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_provider/models/account.dart';
import 'package:flutter_todo_provider/models/settings.dart';

class StorageHelper {
  static const String _useDarkTheme = 'useDarkTheme';
  static const String _userId = 'userId';
  static const String _email = 'email';
  static const String _token = 'token';
  static const String _refreshToken = 'refreshToken';
  static const String _expiryTime = 'expiryTime';

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

  Future<Account> loadAccount() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_userId)) {
      return Account.initial();
    }

    return Account(
      userId: prefs.getString(_userId),
      email: prefs.getString(_email),
      token: prefs.getString(_token),
      refreshToken: prefs.getString(_refreshToken),
      expiryTime: DateTime.parse(prefs.getString(_expiryTime)),
    );
  }

  Future<void> saveAccount(Account account) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userId, account.userId);
    await prefs.setString(_email, account.email);
    await prefs.setString(_token, account.token);
    await prefs.setString(_refreshToken, account.refreshToken);
    await prefs.setString(_expiryTime, account.expiryTime.toIso8601String());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }
}
