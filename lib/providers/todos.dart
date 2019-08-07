import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/models/todo.dart';

class Todos with ChangeNotifier {
  List<Todo> _items = [];

  UnmodifiableListView<Todo> get items => UnmodifiableListView(_items);

  Future fetchTodos() async {
    final url = '${Configuration.FirebaseUrl}/todos.json';
    final response = await http.get(url);
    final todosData = json.decode(response.body) as Map<String, dynamic>;

    todosData.forEach((String id, dynamic json) {
      _items.add(Todo.fromJson(id, json));
    });

    notifyListeners();
  }

  Future addTodo(Todo todo) async {
    final url = '${Configuration.FirebaseUrl}/todos.json';
    final response = await http.post(
      url,
      body: json.encode({
        'title': todo.title,
        'content': todo.content,
        'priority': todo.priority.toString(),
        'isDone': todo.isDone,
        'userId': todo.userId,
      }),
    );

    todo.copyWith(
      id: json.decode(response.body)['name'],
    );
    _items.add(todo);

    notifyListeners();
  }
}
