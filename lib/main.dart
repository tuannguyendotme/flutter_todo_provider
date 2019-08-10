import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/providers/settings.dart';
import 'package:flutter_todo_provider/screens/todos_screen.dart';
import 'package:flutter_todo_provider/screens/settings_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Todos(),
        ),
        ChangeNotifierProvider.value(
          value: Settings(),
        ),
      ],
      child: Consumer<Settings>(
        builder: (context, settings, child) => MaterialApp(
          title: 'Flutter Todo Provider',
          theme: ThemeData(
            primaryColor: Colors.blue,
            accentColor: Colors.blue,
            brightness:
                settings.useDarkTheme ? Brightness.dark : Brightness.light,
          ),
          home: TodosScreen(),
          routes: {
            TodosScreen.routeName: (context) => TodosScreen(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
          },
        ),
      ),
    );
  }
}
