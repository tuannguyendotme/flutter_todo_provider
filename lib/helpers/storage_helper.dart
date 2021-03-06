import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_provider/models/account.dart';
import 'package:flutter_todo_provider/models/settings.dart';

class StorageHelper {
  static const String _useDarkTheme = 'useDarkTheme';
  static const String _showSummary = 'showSummary';
  static const String _userId = 'userId';
  static const String _email = 'email';
  static const String _token = 'token';
  static const String _refreshToken = 'refreshToken';
  static const String _expiryTime = 'expiryTime';

  final SharedPreferences prefs;

  StorageHelper(this.prefs);

  Settings loadSettings() {
    return Settings(
      useDarkTheme: prefs.containsKey(_useDarkTheme)
          ? prefs.getBool(_useDarkTheme)
          : false,
      showSummary:
          prefs.containsKey(_showSummary) ? prefs.getBool(_showSummary) : false,
    );
  }

  Future<void> saveSettings(Settings settings) async {
    await prefs.setBool(_useDarkTheme, settings.useDarkTheme);
    await prefs.setBool(_showSummary, settings.showSummary);
  }

  Account loadAccount() {
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
    await prefs.setString(_userId, account.userId);
    await prefs.setString(_email, account.email);
    await prefs.setString(_token, account.token);
    await prefs.setString(_refreshToken, account.refreshToken);
    await prefs.setString(_expiryTime, account.expiryTime.toIso8601String());
  }

  void clear() {
    prefs.clear();
  }
}
