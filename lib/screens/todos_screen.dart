import 'package:flutter/material.dart';

import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/ui_helper.dart';
import 'package:flutter_todo_provider/widgets/todo_form.dart';
import 'package:flutter_todo_provider/widgets/todos_list.dart';

class TodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Todo'),
      ),
      body: TodosList(),
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
