import 'package:flutter/foundation.dart';

class Settings {
  final bool useDarkTheme;

  Settings({@required this.useDarkTheme});

  Settings copyWith({bool useDarkTheme}) {
    return Settings(
      useDarkTheme: useDarkTheme ?? this.useDarkTheme,
    );
  }
}
