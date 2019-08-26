import 'package:flutter/foundation.dart';

class Account {
  final String userId;
  final String email;
  final String token;
  final String refreshToken;
  final DateTime expiryTime;

  Account({
    @required this.userId,
    @required this.email,
    @required this.token,
    @required this.refreshToken,
    @required this.expiryTime,
  });

  bool get isAuthenticated =>
      expiryTime != null && expiryTime.isAfter(DateTime.now()) && token != null;

  Account.initial()
      : userId = null,
        email = null,
        token = null,
        refreshToken = null,
        expiryTime = null;

  Account copyWith({
    String userId,
    String email,
    String token,
    String refreshToken,
    DateTime expiryTime,
  }) {
    return Account(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      expiryTime: expiryTime ?? this.expiryTime,
    );
  }
}
