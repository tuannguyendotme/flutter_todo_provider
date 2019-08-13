import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/providers/account.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/models/filter.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/ui_helper.dart';
import 'package:flutter_todo_provider/screens/settings_screen.dart';
import 'package:flutter_todo_provider/widgets/todo_form.dart';
import 'package:flutter_todo_provider/widgets/todos_list.dart';

class TodosScreen extends StatefulWidget {
  static const String routeName = '/todos';

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    final todosProvider = Provider.of<Todos>(context, listen: false);
    final currentFilter = todosProvider.filter;

    return Scaffold(
      appBar: AppBar(
        title: Text(Configuration.AppName),
        actions: <Widget>[
          PopupMenuButton<Filter>(
            icon: Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              return [
                CheckedPopupMenuItem<Filter>(
                  checked: currentFilter == Filter.All,
                  value: Filter.All,
                  child: Text('All'),
                ),
                CheckedPopupMenuItem<Filter>(
                  checked: currentFilter == Filter.Done,
                  value: Filter.Done,
                  child: Text('Done'),
                ),
                CheckedPopupMenuItem<Filter>(
                  checked: currentFilter == Filter.NotDone,
                  value: Filter.NotDone,
                  child: Text('Not Done'),
                ),
              ];
            },
            onSelected: (Filter filter) {
              todosProvider.applyFilter(filter);

              setState(() {});
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String choice) {
              switch (choice) {
                case 'Settings':
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  break;

                case 'LogOut':
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: 'LogOut',
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: TodosList(
        onEdit: (Todo todo) {
          showTodoForm(
            context,
            todo,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final accountProvider = Provider.of<Account>(context, listen: false);

          showTodoForm(
            context,
            Todo.initial(accountProvider.userId),
          );
        },
      ),
    );
  }

  void showTodoForm(BuildContext context, Todo todo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Color(0xFF737373),
        height: 420,
        child: Container(
          padding: UIHelper.padding,
          child: TodoForm(todo),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
