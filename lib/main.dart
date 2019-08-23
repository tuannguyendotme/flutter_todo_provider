import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/models/settings.dart' as model;
import 'package:flutter_todo_provider/models/account.dart' as model;
import 'package:flutter_todo_provider/providers/account.dart';
import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/providers/settings.dart';
import 'package:flutter_todo_provider/screens/todos_screen.dart';
import 'package:flutter_todo_provider/screens/settings_screen.dart';
import 'package:flutter_todo_provider/screens/account_screen.dart';

void main() async {
  final storageHelper = StorageHelper();
  final initialSettings = await storageHelper.loadSettings();
  final initialAccount = await storageHelper.loadAccount();

  runApp(MyApp(
    storageHelper: storageHelper,
    initialSettings: initialSettings,
    initialAccount: initialAccount,
  ));
}

class MyApp extends StatelessWidget {
  final StorageHelper storageHelper;
  final model.Settings initialSettings;
  final model.Account initialAccount;

  const MyApp({
    this.storageHelper,
    this.initialSettings,
    this.initialAccount,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Account(this.storageHelper, this.initialAccount),
        ),
        ChangeNotifierProvider(
          builder: (context) =>
              Settings(this.storageHelper, this.initialSettings),
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
            home:
                account.value.isAuthenticated ? TodosScreen() : AccountScreen(),
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
