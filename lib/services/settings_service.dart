import 'package:flutter/foundation.dart';
import 'package:flutter_todo_provider/helpers/storage_helper.dart';
import 'package:flutter_todo_provider/models/settings.dart';

class SettingsService with ChangeNotifier {
  final StorageHelper storageHelper;
  Settings settings;

  SettingsService(StorageHelper storageHelper, Settings initialSettings)
      : this.storageHelper = storageHelper,
        this.settings = initialSettings;

  Future<void> toggleTheme() async {
    final newSettings = settings.copyWith(useDarkTheme: !settings.useDarkTheme);
    await storageHelper.saveSettings(newSettings);

    settings = newSettings;

    notifyListeners();
  }
}
