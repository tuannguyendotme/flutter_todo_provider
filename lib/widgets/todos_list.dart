import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/helpers/ui_helper.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';
import 'package:flutter_todo_provider/widgets/todo_card.dart';

class TodosList extends StatefulWidget {
  final Function onEdit;

  const TodosList({@required this.onEdit});

  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  TodoService _todoService;
  Future<dynamic> _todos;

  @override
  void initState() {
    super.initState();

    _todoService = Provider.of<TodoService>(context, listen: false);
    _todos = _todoService.fetchTodos();
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
            : Consumer<TodoService>(
                builder: (context, todoService, child) => ListView.builder(
                  itemCount: todoService.items.length,
                  itemBuilder: (context, index) {
                    final todo = todoService.items[index];

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
                            await _todoService.removeTodo(todo.id);
                          } catch (e) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Fail to remove todo'),
                              ),
                            );
                          }
                        }
                      },
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          return await UIHelper.confirm(
                              context, 'Are you sure to remove this todo?');
                        } else {
                          return toggleDone(todo.id);
                        }
                      },
                      background: Container(
                        color: Colors.green,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Icon(todo.isDone
                                  ? Icons.check_box_outline_blank
                                  : Icons.check),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.only(left: 16),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }

  Future<bool> toggleDone(String todoId) async {
    try {
      await _todoService.toggleDone(todoId);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: const Text('Fail to update todo status.'),
      ));
    }

    return Future.value(false);
  }
}
