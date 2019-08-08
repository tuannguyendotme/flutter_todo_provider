import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/widgets/todo_card.dart';

class TodosList extends StatefulWidget {
  final Function onEdit;

  const TodosList({@required this.onEdit});

  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  Todos _todosProvider;
  Future<dynamic> _todos;

  @override
  void initState() {
    super.initState();

    _todosProvider = Provider.of<Todos>(context, listen: false);
    _todos = _todosProvider.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _todos,
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

                      return Dismissible(
                        key: ValueKey(todo.id),
                        child: TodoCard(
                          id: todo.id,
                          title: todo.title,
                          priority: todo.priority,
                          isDone: todo.isDone,
                          onEdit: () => widget.onEdit(todo),
                        ),
                        onDismissed: (direction) {
                          _todosProvider.removeTodo(todo.id);
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
