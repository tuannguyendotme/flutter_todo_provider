import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_todo_provider/models/priority.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/models/account.dart';
import 'package:flutter_todo_provider/models/filter.dart';
import 'package:flutter_todo_provider/http_exception.dart';
import 'package:flutter_todo_provider/services/account_service.dart';

class TodoService with ChangeNotifier {
  final AccountService accountService;
  List<Todo> _items = [];
  Filter _filter = Filter.All;

  TodoService(this.accountService);

  Account get _account => accountService.account;

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

  int get allItemsCount {
    return _items.length;
  }

  UnmodifiableListView<Todo> getItemsByPriority(Priority priority) {
    final items = _items.where((t) => t.priority == priority).toList();

    return UnmodifiableListView(items);
  }

  Filter get filter => _filter;

  void applyFilter(Filter newFilter) {
    _filter = newFilter;

    notifyListeners();
  }

  Future fetchTodos() async {
    const String message = 'Fail to fetch todos.';
    final url =
        '${Configuration.FirebaseUrl}/todos.json?auth=${_account.token}&orderBy="userId"&equalTo="${_account.userId}"';

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw HttpException(message);
      }

      final todosData = json.decode(response.body) as Map<String, dynamic>;

      todosData.forEach((String id, dynamic json) {
        _items.add(Todo.fromJson(id, json));
      });

      notifyListeners();
    } catch (e) {
      throw HttpException(message);
    }
  }

  Future addTodo(Todo todo) async {
    const String message = 'Fail to create todo.';
    final url =
        '${Configuration.FirebaseUrl}/todos.json?auth=${_account.token}';

    try {
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

      if (response.statusCode >= 400) {
        throw HttpException(message);
      }

      final newTodo = todo.copyWith(
        id: json.decode(response.body)['name'],
      );
      _items.add(newTodo);

      notifyListeners();
    } catch (e) {
      throw HttpException(message);
    }
  }

  Future updateTodo(Todo todo) async {
    const String message = 'Fail to update todo.';
    final url =
        '${Configuration.FirebaseUrl}/todos/${todo.id}.json?auth=${_account.token}';

    try {
      final response = await http.put(
        url,
        body: json.encode({
          'title': todo.title,
          'content': todo.content,
          'priority': todo.priority.toString(),
          'isDone': todo.isDone,
          'userId': todo.userId,
        }),
      );

      if (response.statusCode >= 400) {
        throw HttpException(message);
      }

      final index = _items.indexWhere((t) => t.id == todo.id);
      _items[index] = todo;

      notifyListeners();
    } catch (e) {
      throw HttpException(message);
    }
  }

  Future removeTodo(String id) async {
    const String message = 'Fail to remove todo.';

    final index = _items.indexWhere((t) => t.id == id);
    var todo = _items[index];

    _items.removeAt(index);
    notifyListeners();

    final url =
        '${Configuration.FirebaseUrl}/todos/$id.json?auth=${_account.token}';

    try {
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _items[index] = todo;
        notifyListeners();

        throw HttpException(message);
      }

      todo = null;
    } catch (e) {
      _items[index] = todo;
      notifyListeners();

      throw HttpException(message);
    }
  }

  Future toggleDone(String id) async {
    const String message = 'Fail to update todo status.';

    var todo = _items.firstWhere((t) => t.id == id);
    var updatedTodo = todo.copyWith(isDone: !todo.isDone);
    final index = _items.indexWhere((t) => t.id == todo.id);

    _items[index] = updatedTodo;
    notifyListeners();

    final url =
        '${Configuration.FirebaseUrl}/todos/$id.json?auth=${_account.token}';

    try {
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

        throw HttpException(message);
      }

      todo = null;
      updatedTodo = null;
    } catch (e) {
      _items[index] = todo;
      notifyListeners();

      throw HttpException(message);
    }
  }
}
