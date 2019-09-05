import 'package:flutter/foundation.dart';

class Settings {
  final bool useDarkTheme;
  final bool showSummary;

  Settings({
    @required this.useDarkTheme,
    @required this.showSummary,
  });

  Settings copyWith({
    bool useDarkTheme,
    bool showSummary,
  }) {
    return Settings(
      useDarkTheme: useDarkTheme ?? this.useDarkTheme,
      showSummary: showSummary ?? this.showSummary,
    );
  }
}
