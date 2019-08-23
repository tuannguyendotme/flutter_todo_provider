import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/models/settings.dart' as model;
import 'package:flutter_todo_provider/providers/account.dart';
import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/providers/settings.dart';
import 'package:flutter_todo_provider/screens/todos_screen.dart';
import 'package:flutter_todo_provider/screens/settings_screen.dart';
import 'package:flutter_todo_provider/screens/account_screen.dart';

void main() async {
  final storageHelper = StorageHelper();
  final initialSettings = await storageHelper.loadSettings();

  runApp(MyApp(
    storageHelper: storageHelper,
    initialSettings: initialSettings,
  ));
}

class MyApp extends StatelessWidget {
  final StorageHelper storageHelper;
  final model.Settings initialSettings;

  const MyApp({
    this.storageHelper,
    this.initialSettings,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) =>
              Settings(this.storageHelper, this.initialSettings),
        ),
        ChangeNotifierProvider.value(
          value: Account(),
        ),
        ChangeNotifierProxyProvider<Account, Todos>(
          initialBuilder: null,
          builder: (context, account, todos) => Todos(account),
        ),
      ],
      child: Consumer<Account>(
        builder: (context, account, child) => Consumer<Settings>(
          builder: (context, settings, child) => MaterialApp(
            title: 'Flutter Todo Provider',
            theme: ThemeData(
              primaryColor: Colors.blue,
              accentColor: Colors.blue,
              brightness: settings.value.useDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
            ),
            home: account.isAuthenticated ? TodosScreen() : AccountScreen(),
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
