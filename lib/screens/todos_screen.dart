import 'package:flutter/material.dart';

import 'package:flutter_todo_provider/models/filter.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/ui_helper.dart';
import 'package:flutter_todo_provider/widgets/todo_form.dart';
import 'package:flutter_todo_provider/widgets/todos_list.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatefulWidget {
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
        title: Text('Flutter Todo'),
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
          showTodoForm(
            context,
            Todo.initial('ZNTkiZIxP8UxwoNyqXqx5ruIkDC3'),
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
    );
  }
}
