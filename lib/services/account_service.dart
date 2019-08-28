import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/http_exception.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';
import 'package:flutter_todo_provider/models/account.dart';

class AccountService with ChangeNotifier {
  StorageHelper storageHelper;
  Account account;
  Timer _autoLogoutTimer;

  AccountService(StorageHelper storageHelper) {
    this.storageHelper = storageHelper;
    this.account = storageHelper.loadAccount();
  }

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

    _saveAccount(responseData);
  }

  void signOut() {
    storageHelper.clear();

    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
      _autoLogoutTimer = null;
    }

    account = Account.initial();

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

    _saveAccount(responseData);
  }

  void _saveAccount(Map<String, dynamic> responseData) {
    final DateTime expiryTime = DateTime.now()
        .add(Duration(seconds: int.parse(responseData['expiresIn'])));
    final newAccount = account.copyWith(
        userId: responseData['localId'],
        email: responseData['email'],
        token: responseData['idToken'],
        refreshToken: responseData['refreshToken'],
        expiryTime: expiryTime);
    storageHelper.saveAccount(newAccount);

    account = newAccount;
    notifyListeners();

    setUpAutoLogoutTimer(expiryTime);
  }

  void setUpAutoLogoutTimer(DateTime expiryTime) {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer.cancel();
    }

    final timeToExpiry = expiryTime.difference(DateTime.now()).inSeconds;
    _autoLogoutTimer = Timer(Duration(seconds: timeToExpiry), signOut);
  }
}
