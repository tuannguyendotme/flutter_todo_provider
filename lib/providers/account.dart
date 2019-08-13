import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_todo_provider/.env.dart';

class Account with ChangeNotifier {
  String _userId;
  String _email;
  String _token;
  String _refreshToken;
  DateTime _expiryTime;

  bool get isAuthenticated => _userId != null;

  String get userId => _userId;

  String get token => _token;

  Future signIn(String email, String password) async {
    final response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${Configuration.ApiKey}',
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final DateTime expiryTime = DateTime.now()
        .add(Duration(seconds: int.parse(responseData['expiresIn'])));

    _userId = responseData['localId'];
    _email = responseData['email'];
    _token = responseData['idToken'];
    _refreshToken = responseData['refreshToken'];
    _expiryTime = expiryTime;

    notifyListeners();
  }

  Future signUp(String email, String password) async {
    final response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${Configuration.ApiKey}',
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final DateTime expiryTime = DateTime.now()
        .add(Duration(seconds: int.parse(responseData['expiresIn'])));

    _userId = responseData['localId'];
    _email = responseData['email'];
    _token = responseData['idToken'];
    _refreshToken = responseData['refreshToken'];
    _expiryTime = expiryTime;

    notifyListeners();
  }
}
