import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';
import 'package:flutter_todo_provider/services/account_service.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';
import 'package:flutter_todo_provider/services/settings_service.dart';
import 'package:flutter_todo_provider/screens/todos_screen.dart';
import 'package:flutter_todo_provider/screens/settings_screen.dart';
import 'package:flutter_todo_provider/screens/account_screen.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  final storageHelper = StorageHelper(prefs);

  runApp(MyApp(storageHelper: storageHelper));
}

class MyApp extends StatelessWidget {
  final StorageHelper storageHelper;

  const MyApp({this.storageHelper});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AccountService(this.storageHelper),
        ),
        ChangeNotifierProvider(
          builder: (context) => SettingsService(this.storageHelper),
        ),
        ChangeNotifierProxyProvider<AccountService, TodoService>(
          initialBuilder: null,
          builder: (context, accountService, todoService) {
            final account = accountService.account;

            if (account.isAuthenticated) {
              accountService.setUpAutoLogoutTimer(account.expiryTime);
            }

            return TodoService(accountService);
          },
        ),
      ],
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
