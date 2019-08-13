import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/http_exception.dart';

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
    final error = responseData['error'];

    if (error != null) {
      var message = error['message'];

      switch (message) {
        case 'EMAIL_NOT_FOUND':
          message = 'Email is not found.';
          break;

        case 'INVALID_PASSWORD':
          message = 'Password is invalid.';
          break;

        case 'USER_DISABLED':
          message = 'The user account has been disabled.';
          break;
      }

      throw HttpException(message);
    }

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
    final error = responseData['error'];

    if (error != null) {
      var message = error['message'];

      switch (message) {
        case 'EMAIL_EXISTS':
          message = 'Email is already exists.';
          break;

        case 'OPERATION_NOT_ALLOWED':
          message = 'Password sign-in is disabled.';
          break;

        case 'TOO_MANY_ATTEMPTS_TRY_LATER':
          message =
              'We have blocked all requests from this device due to unusual activity. Try again later.';
          break;
      }

      throw HttpException(message);
    }

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
