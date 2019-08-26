import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
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
                  final isSignOut = await confirmSigningOut(context);

                  if (isSignOut) {
                    await accountService.signOut();
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'SignOut',
                  child: Text('Sign out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Consumer<SettingsService>(
            builder: (context, settingsService, child) => SwitchListTile(
              activeColor: Theme.of(context).accentColor,
              value: settingsService.settings.useDarkTheme,
              onChanged: (value) {
                settingsService.toggleTheme();
              },
              title: Text('Use dark theme'),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> confirmSigningOut(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure to signing out?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
