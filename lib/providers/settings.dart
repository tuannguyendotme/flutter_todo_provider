import 'package:flutter/foundation.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';
import 'package:flutter_todo_provider/models/settings.dart' as model;

class Settings with ChangeNotifier {
  final StorageHelper storageHelper;
  model.Settings value;

  Settings(StorageHelper storageHelper, model.Settings initialSettings)
      : this.storageHelper = storageHelper,
        this.value = initialSettings;

  Future<void> toggleTheme() async {
    final newSettings = value.copyWith(useDarkTheme: !value.useDarkTheme);
    await storageHelper.saveSettings(newSettings);

    value = newSettings;

    notifyListeners();
  }
}
