import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/screens/todos_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Todos(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Todo Provider',
        home: TodosScreen(),
      ),
    );
  }
}
