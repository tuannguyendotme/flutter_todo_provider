import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/models/settings.dart';
import 'package:flutter_todo_provider/models/account.dart';
import 'package:flutter_todo_provider/services/account_service.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';
import 'package:flutter_todo_provider/services/settings_service.dart';
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
  final Settings initialSettings;
  final Account initialAccount;

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
          value: AccountService(this.storageHelper, this.initialAccount),
        ),
        ChangeNotifierProvider(
          builder: (context) =>
              SettingsService(this.storageHelper, this.initialSettings),
        ),
        ChangeNotifierProxyProvider<AccountService, TodoService>(
          initialBuilder: null,
          builder: (context, accountService, todoService) =>
              TodoService(accountService),
        ),
      ],
      child: Consumer<AccountService>(
        builder: (context, accountService, child) => Consumer<SettingsService>(
          builder: (context, settingsService, child) => MaterialApp(
            title: 'Flutter Todo Provider',
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
