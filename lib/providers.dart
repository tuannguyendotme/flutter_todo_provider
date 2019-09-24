import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_todo_provider/helpers/storage_helper.dart';
import 'package:flutter_todo_provider/services/account_service.dart';
import 'package:flutter_todo_provider/services/settings_service.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';

List<SingleChildCloneableWidget> initializeProviders(SharedPreferences prefs) =>
    [
      Provider.value(
        value: StorageHelper(prefs),
      ),
      ChangeNotifierProxyProvider<StorageHelper, AccountService>(
        initialBuilder: null,
        builder: (context, storageHelper, accountService) =>
            AccountService(storageHelper),
      ),
      ChangeNotifierProxyProvider<StorageHelper, SettingsService>(
        initialBuilder: null,
        builder: (context, storageHelper, settingsService) =>
            SettingsService(storageHelper),
      ),
      ChangeNotifierProxyProvider<AccountService, TodoService>(
        initialBuilder: null,
        builder: (context, accountService, todoService) {
          final account = accountService.account;

          if (account.isAuthenticated) {
            accountService.setUpAutoLogoutTimer(account.expiryTime);
          }

          return TodoService(accountService);
        },
      ),
    ];
