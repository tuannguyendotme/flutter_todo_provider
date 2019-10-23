import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/models/filter.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';
import 'package:flutter_todo_provider/services/account_service.dart';
import 'package:flutter_todo_provider/services/settings_service.dart';
import 'package:flutter_todo_provider/helpers/ui_helper.dart';
import 'package:flutter_todo_provider/screens/settings_screen.dart';
import 'package:flutter_todo_provider/widgets/todo_form.dart';
import 'package:flutter_todo_provider/widgets/todos_list.dart';
import 'package:flutter_todo_provider/widgets/todos_summary.dart';

class TodosScreen extends StatefulWidget {
  static const String routeName = '/todos';

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  TodoService _todoService;
  AccountService _accountService;
  Filter _currentFilter;

  @override
  void initState() {
    super.initState();

    _todoService = Provider.of<TodoService>(context, listen: false);
    _accountService = Provider.of<AccountService>(context, listen: false);

    _currentFilter = _todoService.filter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Configuration.AppName),
        actions: <Widget>[
          Center(
            child: Text(
              _getCurrentFilterText(),
              textScaleFactor: 1.5,
              style: new TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          PopupMenuButton<Filter>(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              return [
                CheckedPopupMenuItem<Filter>(
                  checked: _currentFilter == Filter.All,
                  value: Filter.All,
                  child: const Text('All'),
                ),
                CheckedPopupMenuItem<Filter>(
                  checked: _currentFilter == Filter.Done,
                  value: Filter.Done,
                  child: const Text('Done'),
                ),
                CheckedPopupMenuItem<Filter>(
                  checked: _currentFilter == Filter.NotDone,
                  value: Filter.NotDone,
                  child: const Text('Not Done'),
                ),
              ];
            },
            onSelected: (Filter filter) {
              _todoService.applyFilter(filter);

              setState(() {
                _currentFilter = filter;
              });
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
                    _accountService.signOut();
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
          Consumer<SettingsService>(
            builder: (contexxt, settingsService, child) =>
                settingsService.settings.showSummary
                    ? TodosSummary()
                    : Container(),
          ),
          Expanded(
            child: TodosList(
              onEdit: (Todo todo) {
                _showTodoForm(todo);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showTodoForm(Todo.initial(_accountService.account.userId));
        },
      ),
    );
  }

  String _getCurrentFilterText() {
    switch (_currentFilter) {
      case Filter.Done:
        return 'Done';

      case Filter.NotDone:
        return 'Not Done';

      default:
        return 'All';
    }
  }

  void _showTodoForm(Todo todo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<SettingsService>(
        builder: (context, settingsService, child) => Container(
          color: settingsService.settings.useDarkTheme
              ? const Color(0xFF161616)
              : const Color(0xFF737373),
          height: 400,
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
      ),
    );
  }
}
