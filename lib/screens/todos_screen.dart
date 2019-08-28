import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/widgets/todos_summary.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/models/filter.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';
import 'package:flutter_todo_provider/services/account_service.dart';
import 'package:flutter_todo_provider/helpers/ui_helper.dart';
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
    final todoService = Provider.of<TodoService>(context, listen: false);
    final accountService = Provider.of<AccountService>(context, listen: false);
    final currentFilter = todoService.filter;

    return Scaffold(
      appBar: AppBar(
        title: Text(Configuration.AppName),
        actions: <Widget>[
          PopupMenuButton<Filter>(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              return [
                CheckedPopupMenuItem<Filter>(
                  checked: currentFilter == Filter.All,
                  value: Filter.All,
                  child: const Text('All'),
                ),
                CheckedPopupMenuItem<Filter>(
                  checked: currentFilter == Filter.Done,
                  value: Filter.Done,
                  child: const Text('Done'),
                ),
                CheckedPopupMenuItem<Filter>(
                  checked: currentFilter == Filter.NotDone,
                  value: Filter.NotDone,
                  child: const Text('Not Done'),
                ),
              ];
            },
            onSelected: (Filter filter) {
              todoService.applyFilter(filter);

              setState(() {});
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String choice) async {
              switch (choice) {
                case 'Settings':
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  break;

                case 'SignOut':
                  final isSignOut = await UIHelper.confirm(
                      context, 'Are you sure to signing out?');

                  if (isSignOut) {
                    accountService.signOut();
                  }

                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Settings',
                  child: const Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: 'SignOut',
                  child: const Text('Sign out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TodosSummary(),
          Expanded(
            child: TodosList(
              onEdit: (Todo todo) {
                showTodoForm(
                  context,
                  todo,
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showTodoForm(
            context,
            Todo.initial(accountService.account.userId),
          );
        },
      ),
    );
  }

  void showTodoForm(BuildContext context, Todo todo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: const Color(0xFF737373),
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
