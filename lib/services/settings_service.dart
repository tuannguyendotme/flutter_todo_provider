import 'package:flutter/foundation.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';
import 'package:flutter_todo_provider/models/settings.dart';

class SettingsService with ChangeNotifier {
  StorageHelper storageHelper;
  Settings settings;

  SettingsService(StorageHelper storageHelper) {
    this.storageHelper = storageHelper;
    this.settings = storageHelper.loadSettings();
  }

  Future<void> toggleTheme() async {
    final newSettings = settings.copyWith(useDarkTheme: !settings.useDarkTheme);
    await storageHelper.saveSettings(newSettings);

    settings = newSettings;

    notifyListeners();
  }

  Future<void> toggleSummary() async {
    final newSettings = settings.copyWith(showSummary: !settings.showSummary);
    await storageHelper.saveSettings(newSettings);

    settings = newSettings;

    notifyListeners();
  }
}
