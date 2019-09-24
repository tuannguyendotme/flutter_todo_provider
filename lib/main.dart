import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/providers.dart';
import 'package:flutter_todo_provider/services/account_service.dart';
import 'package:flutter_todo_provider/services/settings_service.dart';
import 'package:flutter_todo_provider/screens/todos_screen.dart';
import 'package:flutter_todo_provider/screens/settings_screen.dart';
import 'package:flutter_todo_provider/screens/account_screen.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: initializeProviders(prefs),
      child: Consumer<AccountService>(
        builder: (context, accountService, child) => Consumer<SettingsService>(
          builder: (context, settingsService, child) => MaterialApp(
            title: Configuration.AppName,
            theme: ThemeData(
              primaryColor: Colors.blue,
              accentColor: Colors.blue,
              brightness: settingsService.settings.useDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
            ),
            home: accountService.account.isAuthenticated
                ? TodosScreen()
                : AccountScreen(),
            routes: {
              AccountScreen.routeName: (context) => AccountScreen(),
              TodosScreen.routeName: (context) => TodosScreen(),
              SettingsScreen.routeName: (context) => SettingsScreen(),
            },
          ),
        ),
      ),
    );
  }
}
