import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/widgets/todo_card.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/providers/todos.dart';

class TodosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Todos>(context, listen: false).fetchTodos(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Todos>(
                  builder: (context, todosData, child) => ListView.builder(
                    itemCount: todosData.items.length,
                    itemBuilder: (context, index) {
                      final todo = todosData.items[index];

                      return TodoCard(
                        key: ValueKey(todo.id),
                        id: todo.id,
                        title: todo.title,
                        priority: todo.priority,
                        isDone: todo.isDone,
                      );
                    },
                  ),
                ),
    );
  }
}
