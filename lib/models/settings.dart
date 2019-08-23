class Settings {
  final bool useDarkTheme;

  Settings({this.useDarkTheme});

  Settings copyWith({bool useDarkTheme}) {
    return Settings(
      useDarkTheme: useDarkTheme ?? this.useDarkTheme,
    );
  }
}
