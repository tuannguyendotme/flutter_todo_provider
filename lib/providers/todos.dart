import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/models/filter.dart';

class Todos with ChangeNotifier {
  List<Todo> _items = [];
  Filter _filter = Filter.All;

  UnmodifiableListView<Todo> get items {
    switch (_filter) {
      case Filter.Done:
        final filteredItems = _items.where((t) => t.isDone).toList();
        return UnmodifiableListView(filteredItems);

      case Filter.NotDone:
        final filteredItems = _items.where((t) => !t.isDone).toList();
        return UnmodifiableListView(filteredItems);

      default:
        return UnmodifiableListView(_items);
    }
  }

  Filter get filter => _filter;

  void applyFilter(Filter newFilter) {
    _filter = newFilter;

    notifyListeners();
  }

  Future fetchTodos() async {
    print('fetchTodos');

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

  Future updateTodo(Todo todo) async {
    final url = '${Configuration.FirebaseUrl}/todos/${todo.id}.json';
    await http.put(
      url,
      body: json.encode({
        'title': todo.title,
        'content': todo.content,
        'priority': todo.priority.toString(),
        'isDone': todo.isDone,
        'userId': todo.userId,
      }),
    );

    final index = _items.indexWhere((t) => t.id == todo.id);
    _items[index] = todo;

    notifyListeners();
  }

  Future removeTodo(String id) async {
    final url = '${Configuration.FirebaseUrl}/todos/$id.json';
    await http.delete(url);

    _items.removeWhere((t) => t.id == id);

    notifyListeners();
  }
}
