import 'package:flutter/foundation.dart';

class Settings with ChangeNotifier {
  bool _useDarkTheme = false;

  bool get useDarkTheme => _useDarkTheme;

  void toggleTheme() {
    _useDarkTheme = !_useDarkTheme;

    notifyListeners();
  }
}
