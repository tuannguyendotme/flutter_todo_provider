# Flutter Todo

Yet another Todo app, now using Flutter.

## Getting Started

This Todo app is implemented using Flutter (with Provider for state management) and Firebase.

Features:

- Create/edit todo
- Delete todo by swipping
- Mark done/not done by swipping
- Filter todo list by status (all/done/not done)
- Display summary (can be toggled in settings)
- Change theme (light to dark and vice versa) at runtime
- Login/logout
- Register new account

![UI Dark](ui_dark.png?raw=true)
![UI Light](ui_light.png?raw=true)

To get start, run below command in Terminal

```bash
cp .env.example.dart .env.dart
```

then add Firebase database's URL and API key to .env.dart.
