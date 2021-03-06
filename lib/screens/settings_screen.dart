import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/helpers/ui_helper.dart';
import 'package:flutter_todo_provider/services/settings_service.dart';
import 'package:flutter_todo_provider/services/account_service.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Configuration.AppName),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) async {
              switch (choice) {
                case 'SignOut':
                  final accountService =
                      Provider.of<AccountService>(context, listen: false);
                  final isSignOut = await UIHelper.confirm(
                      context, 'Are you sure to signing out?');

                  if (isSignOut) {
                    accountService.signOut();
                  }

                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'SignOut',
                  child: const Text('Sign out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Consumer<SettingsService>(
        builder: (context, settingsService, child) => ListView(
          children: <Widget>[
            SwitchListTile(
              activeColor: Theme.of(context).accentColor,
              value: settingsService.settings.useDarkTheme,
              onChanged: (value) {
                settingsService.toggleTheme();
              },
              title: const Text('Use dark theme'),
            ),
            SwitchListTile(
              activeColor: Theme.of(context).accentColor,
              value: settingsService.settings.showSummary,
              onChanged: (value) {
                settingsService.toggleSummary();
              },
              title: const Text('Show task summary'),
            ),
          ],
        ),
      ),
    );
  }
}
