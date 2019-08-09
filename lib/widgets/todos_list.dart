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
      initialData: [],
      future: _todos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return snapshot.connectionState == ConnectionState.waiting
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
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          try {
                            await _todosProvider.removeTodo(todo.id);
                          } catch (e) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Fail to remove todo'),
                              ),
                            );
                          }
                        }
                      },
                      confirmDismiss: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          return confirmRemove();
                        } else {
                          return toggleDone(todo.id);
                        }
                      },
                      background: Container(
                        color: Colors.green,
                        child: Icon(todo.isDone
                            ? Icons.check_box_outline_blank
                            : Icons.check),
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
              );
      },
    );
  }

  Future<bool> confirmRemove() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure to remove this todo?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }

  Future<bool> toggleDone(String todoId) async {
    try {
      await _todosProvider.toggleDone(todoId);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Fail to update todo status.'),
      ));
    }

    return Future.value(false);
  }
}
