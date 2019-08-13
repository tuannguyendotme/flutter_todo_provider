import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/models/filter.dart';
import 'package:flutter_todo_provider/http_exception.dart';
import 'package:flutter_todo_provider/providers/account.dart';

class Todos with ChangeNotifier {
  final Account account;
  List<Todo> _items = [];
  Filter _filter = Filter.All;

  Todos(this.account);

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
    final url =
        '${Configuration.FirebaseUrl}/todos.json?auth=${account.token}&orderBy="userId"&equalTo="${account.userId}"';
    final response = await http.get(url);

    try {
      final todosData = json.decode(response.body) as Map<String, dynamic>;

      todosData.forEach((String id, dynamic json) {
        _items.add(Todo.fromJson(id, json));
      });

      notifyListeners();
    } catch (e) {
      throw HttpException('Fail to fetch todos');
    }
  }

  Future addTodo(Todo todo) async {
    final url = '${Configuration.FirebaseUrl}/todos.json?auth=${account.token}';
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

    final newTodo = todo.copyWith(
      id: json.decode(response.body)['name'],
    );
    _items.add(newTodo);

    notifyListeners();
  }

  Future updateTodo(Todo todo) async {
    final url =
        '${Configuration.FirebaseUrl}/todos/${todo.id}.json?auth=${account.token}';
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
    final index = _items.indexWhere((t) => t.id == id);
    var todo = _items[index];

    _items.removeAt(index);
    notifyListeners();

    final url =
        '${Configuration.FirebaseUrl}/todos/$id.json?auth=${account.token}';
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items[index] = todo;
      notifyListeners();

      throw HttpException('Fail to remove todo.');
    }

    todo = null;
  }

  Future toggleDone(String id) async {
    var todo = _items.firstWhere((t) => t.id == id);
    var updatedTodo = todo.copyWith(isDone: !todo.isDone);
    final index = _items.indexWhere((t) => t.id == todo.id);

    _items[index] = updatedTodo;
    notifyListeners();

    final url =
        '${Configuration.FirebaseUrl}/todos/$id.json?auth=${account.token}';
    final response = await http.put(
      url,
      body: json.encode({
        'title': updatedTodo.title,
        'content': updatedTodo.content,
        'priority': updatedTodo.priority.toString(),
        'isDone': updatedTodo.isDone,
        'userId': updatedTodo.userId,
      }),
    );

    if (response.statusCode >= 400) {
      _items[index] = todo;
      notifyListeners();

      throw HttpException('Fail to update todo status.');
    }

    todo = null;
    updatedTodo = null;
  }
}
